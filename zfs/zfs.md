
# ZFS Cheatsheet + Backups tutorial

------------------------------------------------------------------
## Toplist

	disk.txt (really)

	#1 zfs learning resource! :
	https://pthree.org/2012/12/20/zfs-administration-part-xiii-sending-and-receiving-filesystems/

	https://www.thegeekdiary.com/the-ultimate-zfs-interview-questions/?PageSpeed=noscript     # good summary / tutorial here (+I still use man pages)
	https://www.howtoforge.com/tutorial/how-to-install-and-configure-zfs-on-debian-8-jessie/  # this looks technical/ detailed

	VMs:
		https://github.com/openzfs/zfs/pull/7823

		"Don't store RAW files on ZFS as files. There is no benefit and it is not as fast as it
		could be. ZVOL is perfect for that and you can snapshot a VM at any time and you have a
		constant (vol)block size."

		On the other hand, zol is young and in particular zvols have some genuine
		zfs-internal code issues (bugs) as at 20200701 - where perf not an issue, files for e.g.
		luks/cryptsetup/veracrypt backing are just fine.

------------------------------------------------------------------
## Cmd summary

	# info:
	zfs list
	zfs [un]mount

	zpool list
	zpool list -vP
	zpool list -vPL

	zpool history [poolName]

	zpool import -d /dev/disk/by-id                             # attach a drive, then see what can be used/ imported by zpool:
	zpool import -d /dev/disk/by-id name                        # import a pool

	zpool export name                                           # prepare to detach drive (write all buffers/ sync disk, and mark drive as exported)
	zpool export -f name                                        # force export (forces/tries to unmount all mounts of this drive's zfs filesystems)

	# zfs pools (disks/ disk groups), ashift option is sector size, 2^12=4096 bytes, default mountpoint is /zpool-name ;
	# ashift is not always properly detected, and severely affects performance.
	# On Linux, ONLY use /dev/disk/by-[uu]id/... names when creating new pools!
	zpool create -o ashift=12 poolName /dev/disk/by-uuid/...
	zpool create -o ashift=12 poolName /dev/disk/by-id/...

	zpool create -o ashift=12 -O relatime=on -O compression=on -m target-mountpoint poolname device

	# For backup pools, canmount=noauto (but still mounted at pool creation):
	zpool create -o ashift=12 -O relatime=on -O compression=on -O canmount=noauto -m bu_mnt bu_pool dev

	# Since we might still use bu_pool as scratch/emergency space etc, put backups in a tidy sub fs:
	zfs create bu_pool/bu

		# dmc "device mapper crypt vol -
	zpool create -o ashift=12 -O relatime=on -O compression=on -m target-mountpoint dmcv- /dev/disk/by-id/dm-uuid-CRYPT-LUKS1-...

	zpool set comment="..." poolName                            # set settable property after creation
	zpool get all poolName                                      # list all properties and features of pool

	zfs set relatime=on poolName                                # set pool "root filesystem" property, for default values/ inheriting in sub-filesystems, after pool creation
	zfs set compression=on poolName

	zpool create -f name /dev/disk/by-id/blah                   # force, override existing partition table etc - only use if needed and MAKE SURE you're not clobbering existing disk!
	zpool destroy name
		# if unsure if newer (above 1TiB) drive is deceptive in sector size advertisement, check it FIRST! (see disk.txt):
		lsblk -o NAME,PHY-SeC
		cat /sys/block/sda/queue/physical_block_size
		cat /sys/block/sdX/queue/physical_block_size

	# zfs filesystems - for storing files:
	zfs list
	zfs list -t all
	zfs create poolName/fs-name
	zfs create -o relatime=on -o compression=off poolName/fs-name   # compression + relatime should be inherited (i.e., should set in root zfs of this pool), but compression might be set off e.g. for youtube zfs
	zfs create -m /my/preferred/mountpoint poolName/fs-name
	zfs destroy poolName/fs-name

	# properties:
	zfs get all                                                 # may have a lot of output
	zfs get all pool/youtube                                    # view [ all | specific[,property,names] ] properties for all (if no name) or named datasets
	zfs set relatime=on pool/youtube                            # set property after creation
	zfs set mountpoint=/z/dev pool/dev

	# snashots are read only and light weight, use liberally for backups:
	zfs list -t [ snap | snapshot | all ]
	zfs list -t snapshot -o name -s name                        # use this version if you have many 100s or 1000s of snapshots and performance is an issue

	# as at 20200629, must add `-r` when specifying `filesystem` and naming a filesystem, see https://github.com/openzfs/zfs/issues/10130 , e.g. this should work:
	zfs list -rt filesystem,snap pool1

	# USE ISO date format in your snapshot names - this makes scripting and listing etc work really well.
	# e.g. yyyyMMdd or yyyy-MM-dd , e.g. 20201130 or 2020-11-30

	zfs snapshot [-r] pool/filesystem@20180831                  # create a snapshot (-r means recursively for all sub-datasets (filesystems, volumes))
	zfs rollback pool/filesystem@20180831                       # rollback a zfs filesystem to a previous point in time (marked by a snapshot) - destroys snapshots and bookmarks that are more recent than the named snapshot
	zfs destroy pool/filesystem@20180831


------------------------------------------------------------------
## ZFS Backups - send/recv

--------------
### Step 0 - Create at least 1 snapshot of source pool/filesystem to backup

	# Locate the source pool/filesystem you are going to backup to the target drive:
	zpool list
	zfs list
	SRC_POOL="pool1.."

	# Locate/name the source snapshot you will use to make a backup (ISO date format works
	# really well):
	SRC_SNAP=20200628

	SNAPSHOT=$SRC_POOL@$SRC_SNAP

	# If you have not done so already, make a recursive snapshot of your pool and all its sub
	# filesystems:
	zfs snapshot -r $SNAPSHOT

	# Have a look see:
	zfs list -rt snap,filesystem $SRC_POOL


--------------
### Step 1 - Init new (e.g. USB) 'backups' disk/drive

	# NOTE: some newer (as at 2020) SSDs need ashift=13 (8k sector/block size)!

	# Connect USB drive and create a "backup" pool containing this drive (single-drive zfs zpool):

	# Choose a name - this is the backup pool's/drive's  a) pool name,  b) pool's root
	# filesystem name, and  c) pool/root-fs mountpoint basename :
	BAK_POOL=zb2t01

	# The tmp/bak pool's parent mount dir:
	DMNT=/media/zen/pool
	mkdir $DMNT

	# ALWAYS use by-id or by-uuid - NEVER use /dev/sd[bcdX] !! :
	BAK_DEV=/dev/disk/by-id/ata-TOSHIBA_MQ040000001

	# (On newer SSD drives, ashift may be 13, not 12, and is probably auto-detected - if so,
	# change or remove that option accordingly.)
	zpool create -o ashift=12 -O relatime=on -O compression=on -O canmount=noauto -m $DMNT/$BAK_POOL $BAK_POOL $BAK_DEV
	zpool list

	# Create bak drive (sub) filesystem "bu" to contain backups, and create a sub-sub filesystem
	# to contain/locate the source pool's backups:
	zfs create $BAK_POOL/bu
	BAK_DEST=$BAK_POOL/bu/$SRC_POOL
	zfs create $BAK_DEST
	zfs list $BAK_POOL


--------------
### Step 2 - Create initial "full" source pool backup

	# Step 2.c - On any -new- target backup device, we usually first create a "full" (i.e.
	# non-incremental!) zfs filesystem stream, e.g.:
	zfs send -cvR $SNAPSHOT | zfs receive -vudF -o canmount=noauto $BAK_DEST

	# Step 2.a - alternatively, install `pv`, and then do a zfs dry run as follows:
	zfs send -ncvR $SNAPSHOT

	# and in the output, look for the line "total estimated size is 194G" (your total should be
	# different), and set estimated size:
	SIZE=194G   # NOTE: `pv` does NOT accept decimal place - so just round up or down

	# then run your initial "full" backup as follows:
	zfs send -cvR $SNAPSHOT | pv -petars $SIZE | zfs recv -vudF -o canmount=noauto $BAK_DEST


--------------
### Step 3 - Export and unplug backup drive(s)

	# Backup is finished, so now export the backup pool (this is similar to umount)

	zpool export $BAK_POOL

	# and spin down the disk drive(s) to be unplugged (if it's a magnetic rust bucket HDD):
	hdparm -y $BAK_DEV   [ $BAK_DEV2 ... ]

	# and finally wait about 6 seconds for the HDD(s) to stop spinning, then you may safely
	# unplug your zpool backup drive(s) and store in a clean, cool, dry, dust-free location.


--------------
### Step 4 - Do subsequent "incremental" zfs zpool backup (assumes prior "full" backup)

	# Some time goes by, perhaps a day, and now we want to do just an incremental backup of the
	# delta since yesterday;

	# So we make a new recursive snapshot:
	SRC_SNAP2=20200629
	SNAPSHOT2=$SRC_POOL@$SRC_SNAP2
	zfs snapshot -r $SNAPSHOT2

	# Connect your USB backup drive(s), wait a few seconds, then ask zfs to tell us if there is
	# a valid pool which could be imported:
	zpool list
	zpool import

	# if your backup pool is not shown, something went wrong; if it is shown, import it without
	# mounting:
	zpool import -N $BAK_POOL
	zpool list

	# This time we make an incremental ("-I" option) backup:
	# dry run again:
	zfs send -ncvRI $SNAPSHOT $SNAPSHOT2

	# set size again:
	SIZE=17M  # change according to output of dry run

	# and this time we do the actual, but incremental, backup:
	zfs send -cvRI $SNAPSHOT $SNAPSHOT2 | pv -petars $SIZE | zfs recv -vudF -o canmount=noauto $BAK_DEST

	# WARNING: Always `zpool export ...` your pool before detaching USB drives!  See "Step 3" above.


--------------
### Step 5 - Easily create a full additional backup drive

	# Some time goes by, perhaps a week, and a second separate full backup drive is wanted.

	# Connect a new blank USB drive (wiped/no partition table) and identify it:
	BAK_DEV2=/dev/disk/by-id/ata-TOSHIBA_MQ040000378   # ALWAYS use by-id or by-uuid - NEVER use /dev/sd[bcdX] !!

	# Now plug in first/original USB backup drive, wait a few seconds and import the backup
	# pool:
	zpool import -N $BAK_POOL
	zpool list

	# Then 'attach' the new drive to the old drive as a RAID mirror (use the `-f` option if new
	# drive BAK_DEV2 is not empty and you're really really sure):
	zpool attach [-f] -o ashift=12 $BAK_POOL $BAK_DEV $BAK_DEV2

	# If all went well, BAK_DEV and BAK_DEV2 are now a RAID mirror!  And on top, zfs is now busy
	# syncing your two drives.  Since they're both through USB, if you have a normally large
	# amount of data in your zpool, it can take a long time to sync the two drives (for zfs to
	# do it's automatic "resilver"), so get status updates as follows:
	zpool status $BAK_POOL

	# At the same time this sync is happening, you can do another backup send/recv while
	# waiting, zfs is notoriously "available", but if feeling cautious, you can wait first.

	# When zfs finishes synchronizing, and you've added your daily backup, time to unplug
	# your backup drives again:

	# WARNING: Always `zpool export ...` your pool before detaching USB drives!  See "Step 3" above.


--------------
### Step 6 - Do a full scan (check for errors) of your backup drive(s)/ bak pool

	# First attach one or more of your backup drives, wait for them to spin up, then import:
	zpool import -N $BAK_POOL

	# Now we can scan, and if a mirror drive is attached, bad sectors are automatically fixed!:
	zpool scrub $BAK_POOL

	# Check the scrub status as it runs:
	zpool status $BAK_POOL

	# If a drive has problems, consider further education:
	https://pthree.org/2012/12/11/zfs-administration-part-vi-scrub-and-resilver/

	# WARNING: Always `zpool export ...` your pool before detaching USB drives!  See "Step 3" above.


--------------
### Step 7 - Easily replace a bad/failing backup drive

	# If one of your two backup (mirror) drives is lost or damaged, plug in the still good
	# drive, then plug in a new ("third") backup drive to replace the bad/dead drive, and then
	# run the following (change BAK_DEV to BAK_DEV2 as needed):
	zpool import -N $BAK_POOL
	zpool replace [-f] -o ashift=12 $BAK_POOL $BAK_DEV $BAK_DEV3

	# Alternatively, if the "bad" backup drive just has some bad sectors, zfs can use it if
	# needed to resilver your new/third backup drive, so plug in all 3 drives and do something
	# like this:
	zpool import -N $BAK_POOL
	zpool attach [-f] -o ashift=12 $BAK_POOL $BAK_DEV $BAK_DEV3

	# which would result in a 3 way mirror of BAK_DEV, BAK_DEV2 and BAK_DEV3.

	# Once zfs has finished resilvering the new/third backup drive, you can `zfs remove` the
	# dodgy backup drive from your backup pool, something like this:
	zpool remove $BAK_POOL $BAK_DEV2

	# Once all done, export, spin down, and unplug.

	# WARNING: Always `zpool export ...` your pool before detaching USB drives!  See "Step 3" above.



------------------------------------------------------------------
## Moar commands

	# Example: backup source "zpis1t/..." pool (and all sub fs/vols/snaps, up to snapshot "20190920-13.32"), creating/copying source into target pool/fs "bak1t/backups/zpis1t/...":
	zfs snapshot -r zpis1t@20190920-13.32                       # create recursive snapshot of zpis1t pool/fs
	zfs create bu_pool/bu/zpis1t                                # create parent zfs filesystem that I want to store these backups into
	zfs send -vwR zpis1t@20190920-13.32 | zfs receive -vduF bu_pool/bu/zpis1t  # create full recursive backup (no `-I`)

	# to do similar, but make the backup drive a new primary, i.e. creating/copying source into target pool/fs "bak1t/...":
	zfs send -Rcv zpis1t@20190920-13.32 | zfs receive -d bak1t  # send to backup drive/pool, it will be a new "primary" drive
	# but NOTE, zfs (and zpool) have easy and powerful `zfs rename` commands

	# See also:
	#   Make send/ receive resumable:
	#   https://unix.stackexchange.com/questions/343675/zfs-on-linux-send-receive-resume-on-poor-bad-ssh-connection
	#
	#   https://pthree.org/2012/12/20/zfs-administration-part-xiii-sending-and-receiving-filesystems/
	#   https://unix.stackexchange.com/questions/289127/zfs-send-receive-with-rolling-snapshots
	#   https://docs.oracle.com/cd/E18752_01/html/819-5461/gbchx.html
	#   https://blog.fosketts.net/2016/08/18/migrating-data-zfs-send-receive/

	zfs send pool/youtube@20180831 > /my/backup/yt.bak          # make a fs/dataset backup of pool/youtube filesystem (entire? snapshot delta??)
	zfs receive -d otherpool/youtube < /my/backup/yt.bak        # import/ create a zfs filesystem, from a "zfs send"ed backup
	zfs send tank/yt@today | zfs receive -d pool2/youtube       # all in one

	# the following comes from thegeekdiary.com (above) but I don't know that it's quite correct (it may be)
	# node02 # zfs create n2pool/testfs a                       # (create a test file-system on another system)
	# node01 # zfs send n1pool/fs1@oct2013 | ssh -e none user@node02 "zfs receive -d n2pool/testfs"
	# node01 # zfs send -i @sept2013 n1pool/fs1@oct2013 | ssh -e none user@node02 zfs recv n2pool/testfs    # send only incremental data

	# local tested send/receive:
	zfs send -vRwI primary/krypt@20190914 primary/krypt@20190920 | zfs receive -vduF -o canmount=noauto bak1t/primary


	# clones are zfs filesystems or "read-write snapshots" (made from snapshots), hevy use devolves- orig blocks unused and not reclahmable:
	zfs clone pool/fs1@snapName pool/fs1/cloneName              # create clone as sub-filesystem
	zfs clone pool/fs1@snapName pool/cloneName                  # create clone as separate filesystem
	zfs destroy pool/cloneName                                  # delete the clone

	# bookmarks - lighter weight that snapshots, if you regularly do backups AND have a lot of file churn (created + deleted files):
	https://utcc.utoronto.ca/~cks/space/blog/solaris/ZFSBookmarksWhatFor
	http://list.zfsonlinux.org/pipermail/zfs-discuss/2017-January/027104.html
	zpool set feature@bookmarks pool                            # first enable the feature
	zfs bookmark pool/fs1@snapName                              # make a snapshot - wrong I think
	zfs snapshot pool/fs1@snapName                              # make a snapshot - correct I think
	zfs bookmark pool/fs1@snapName pool/fs1#bookmarkName        # make a bookmark
	zfs send -i #bookmarkName pool/fs1#bookmarkName ...         # can be used for incremental send
	zfs destroy pool/fs1#bookmarkName


	# Features and compression: http://open-zfs.org/wiki/Performance_tuning#Compression
	check we are using lz4 compression feature (default in newer zfs/zpools as at 20180831):
	zpool get feature@lz4_compress pool
	NAME    PROPERTY              VALUE   SOURCE
	pool    feature@lz4_compress  active  local

	should show feature@lz4_compress for each pool. If not, if old pool, then upgrade to get that that feature (or activate the feature:
	zpool upgrade ...

	# fix disconnected/reconnected USB drive:
	# primary consideration is to CREATE POOLS using /dev/disk/by-id/... names, NOT /dev/sdX names!
	# SO, if you HAVE used /dev/sdX :
	# when drive is disconnected, try this (before reconnecting):
	zpool clear poolname
	# next, try to reconnect the drive in a way which causes it to get the same /dev/sdX name
	# try adding/ removing other devices, to try to get the old /dev/sd name back for the zpool USB drive at issue
	# finally, run this once or twice again, after reconnecting:
	zpool clear poolname # sometimes, may have to run this twice
	# FIXING the dev name(s) - do this AFTER getting the pool running again (by reboot or replugging and zpool clear):
	zpool export pool
	zpool import -d /dev/disk/by-id/ pool
	zpool import -d /dev/disk/by-uuid/ pool


------------------------------------------------------------------
## Notes

A zfs filesystem is also called a dataset (especially in the zfs man page).

Show the mountpoint for the root zfs filesystem in a pool that is imported and root filesystem mounted:

	zfs list | grep fs_name
	zfs get mountpoint fs_name
	zfs get -H mountpoint fs_name
	zfs get -Hr mountpoint fs_name
	zfs get -Hrt filesystem mountpoint fs_name

Change the default mountpoint for a zpool's root filesystem:

	zfs set mountpoint=/new/mount/point fs_name
	zfs set mountpoint=/new/mount/point zpool_name

Note that `fs_name` is the same as `zpool_name`, for the root dataset/ root filesystem on that
zfs zpool.

Or same, for a sub filesystem/ volume:

	zfs set mountpoint=/new/mount/point fs_name/fs2_name


Copy/duplicate a zfs volume/filesystem, from one pool to another, and monitor the transfer (assumes ~85G to be transferred, modify to suit of course):

	zfs send zpih2t/z/vms | pv -petars 85G | zfs receive zpis1t/z/vms

