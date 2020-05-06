# ZFS/ ZoL quick fixes

Some ZFS/ZoL stuff.  `zmount` and `zumount` are site specific convenience scripts for their
author, which may assist others trying to figure this out but will not work out of the box.

ZFS is convenient. Very convenient for daily backups and more frequent snapshots, especially if
you use a script to maintain (delete older not wanted) snapshots.

ZFS is a new mindset, and a whole bunch of new commands (new muscle memory), but a few hours
reading and experimenting brings comfortability.

 - [ZFS snippets/ commands cheat sheat](zfs.txt)

 - [links re backups with ZFS](backups.txt)

 - [zmount (symlink also as zumount) bringup + teardown script (site specific atm)](zmount)

 - Do NOT hesitate to make zfs snapshots!  They will save your bio-friendly bacon AND they are
   scriptable, renameable, deleteable, and send-/receive-able.  Use them.

 - The #1 top shelf ZFS feature is sending and receiving zfs filesystems, snapshots, and ranges
   of snapshots.  Use it.

 - ZoL (ZFS on Linux) as at 2019 commands will HANG if you disconnect a single-drive `zpool`
   (e.g. a USB drive being the storage for a single zpool) without first running **`zpool
   export`** !  The only way to get the various hung `zfs` and `zpool` commands working again,
   is to reboot!  This is unfortunate since ZFS is a wonderful filesystem to use on USB drives.

 - Use ZFS on your USB attached drives - backups become a breath of fresh air and joy to use
   (within a short learning curve achieved at least), and thereby an easy daily affair, rather
   than yearly "if you're lucky."

 - A recursive snapshot followed by send | receive is so simple, use it!

```bash
# Plug in USB drive (created as a single drive zpool earlier)
zpool import backup-pool  # import your backup pool:
# Note: a zfs pool name (e.g. "primary") usually has a root fs with the same name:
zfs snapshot -r primary@20190930-20:03  # recursive snapshot for today's backup
zfs send -vRwI @earlier-snapshot primary@20190930-20:03 \
| zfs receive -vduF -o canmount=noauto backup-pool/backups/primary
# voi la, backup every day
```


## Initialization, set up of zfs, krypts, and standardized mounting environment

**Use case:** Laptop, small root partition, large data partition

Laptops have usually 1 or 2 internal drives. Primary drive loads the OS, possibly with full disk
encryption (FDE) and with Debian as at 2019 this is usually an `ext4` filesystem.

 - `$HOME` and all work files wants to be on ZFS for snapshots and backups, so the large
   secondary partition is a single "device" zpool.

 - Use ashift=12 for SSDs (and perhaps large HDDs?).  `ashift` is not always properly detected,
   and severely affects performance.

 - Have encrypted $HOME etc, as a ZFS volume.

```bash
# Do all the following as root. WARNING, the following assumes you can login as root without
# using sudo; adjust accordingly if you need other.

# make sure user is logged out, reboot and only log in as root to ensure clean environment.
PRIMARY_USER=`id -un 1000`
PRIMARY=datapool  # assuming primary "datapool" is mounted at "/datapool"
zpool create -o ashift=12 -O relatime=on -O compression=on -O -m /$PRIMARY $PRIMARY /dev/sdaX  # choose dev name carefully

# Only do this if you have already set a root password (when logged in as root, run 'passwd'):
chown root.root /home/$PRIMARY_USER  # make sure user cannot mistake being in $HOME; WARNING

# encrypted volumes are not compressible:
zfs create -o compression=off $PRIMARY/krypt  # if you have >1 user, create '$PRIMARY/$USER/krypt'

# create 'standard' "krypts" per-user mount point, vastly simplifies future scripting:
mkdir -p /krypt/$PRIMARY_USER  # leave owner as root.root

make_krypt () {
	VNAME=$1; SIZE=$2
	KRYPT=$PRIMARY/krypt/$VNAME
	KMOUNT=/krypt/$PRIMARY_USER/$VNAME/$VNAME  # This is a useful hierarchy in recovery ops!

	dd of=$KRYPT count=0 seek=1 bs=$SIZE       # create sparse file (seek, not count/write!)
	cryptsetup -y luksFormat $KRYPT            # this asks for password to be repeated
	cryptsetup open $KRYPT $VNAME              # HDD version
	# cryptsetup open --allow-discards $KRYPT $VNAME  # SSD version

	mkdir -p $KMOUNT                           # do NOT change dir ownership yet, leave as root.root!
	# ashift should match the parent (primary data pool in this case):
	zpool create -o ashift=12 -O relatime=on -O compression=on -O -m $KMOUNT $VNAME /dev/mapper/$VNAME
	# (zpool create - may be use /dev/disk/by-id or by-uuid device name... not sure)

	chown $PRIMARY_USER.$PRIMARY_USER $KMOUNT  # only now, the mounted fs is writable by PRIMARY_USER
	# (still, e.g. for VM disks, you may want to keep as root.USER or something ? .. whatever works)

	df -h  $KMOUNT  # give yourself a reminder you now have a place to put stuff
}
# create krypt vols as files in parent zfs volume, standard dest mount, etc:
make_krypt v000 100M   # sparse (grow on demand) passwords vault
make_krypt v001 500G   # sparse HOME krypt
make_krypt v002 10T    # sparse data/ VMs etc krypt

# set up $HOME:
HOME_NAME=${PRIMARY_USER}-deb10  # this is the zfs filesystem name we shall use ("debian 10")
zfs create v001/$HOME_NAME
HOME_SRC=/krypt/$PRIMARY_USER/v001/v001/$HOME_NAME
chown $PRIMARY_USER. $HOME_SRC

# the magical bind mount - do NOT do this whilst PRIMARY_USER is logged in anywhere (do as root)
# i.e. make sure ALL PRIMARY_USER logins, are logged out. :
#mount --bind $HOME_SRC /home/$PRIMARY_USER  # see section below "login, logout, bringup, teardown"
# Now you can login as PRIMARY_USER

# Clean up:
umount /home/$PRIMARY_USER
zpool export v002 # etc
zpool export v000
zpool export v001

cryptsetup close v002 # etc
cryptsetup close v000
cryptsetup close v001

zpool export $PRIMARY
```

 - There are recommendations to only use non-sparse krypts (encrypted volumes).  For $HOME,
   sparse is a god send.  For a primary krypt to store passwords etc, perhaps non-sparse is a
   little more secure, though the purported advantages are most probably lost with ZFS backups
   happening regularly (delta blocks are clearly identified, if you know how to look at the
   innards of ZFS).

 - Question: how does ashift relate when e.g. an ashift=12 drive is being backed up to an
   ashift=10 drive?

 - Note: Having all our krypts in a parent ZFS pool/volume, means we can do all our backups from
   the parent, and we can still do snapshots in the krypt vols when they are `zpool import`ed -
   best of all worlds.


## Login, logout, bringup, teardown (ZFS encrypted /home/USER dir)

TODO: determine systemd tweaks/configs to automate this, so user just enters passwords at cmd
line, just like when unlocking FDE at boot.

### Bringup

In the meantime (after having done the initialization/ setup above), boot up, then at the
graphical login prompt, press e.g. `<CTRL>-<ALT>-<F6>` to go to a Linux console, then bringup:

```bash
# On bootup at graphical login screen, press <CTRL>-<ALT>-<F6>, then login as root, then:
# This is the bringup - import primary ZFS datapool, unlock krypts, import those zpools:
zfs import $PRIMARY
unlock_and_mount () {
	VNAME=$1
	cryptsetup open /$PRIMARY/krypt/$VNAME $VNAME
	zpool import $VNAME
}
unlock_and_mount v000
unlock_and_mount v001  # this is usually the only essential one ("HOME" krypt)
# ... etc
mount --bind /krypt/$PRIMARY_USER/v001/v001 /home/$PRIMARY_USER
# (WARNING: we could alternatively run 'zfs set mountpoint=/home/blah', but if you run
# multiple versions (e.g. Debian stable and Debian sid) or need to futz with backups of
# your /home/blah (e.g. to recover or copy from or between backups), it's just easier and
# simpler to have the primary mount elsewhere, AND in a standardized location, and do the
# bind mount on demand...)
```

### Teardown

Finally the difficult part which would be nice to automate with appropriate systemd config:

```bash
# Logout (NOT shutdown) of your graphical desktop, then press <CTRL>-<ALT>-<F6> and
# login as root, then:
systemctl stop $PRIMARY_USER@1000
systemctl stop $PRIMARY_USER-1000.slice  # only needed if something non standard happened

zpool export v002 # etc
zpool export v000
zpool export v001

cryptsetup close v002 # etc
cryptsetup close v000
cryptsetup close v001

zpool export $PRIMARY
```

### Automating bringup and teardown

For some ideas of how to script the bringup and teardown, see a [site specific script
file](zmount) for some ideas (symlink it as zumount as well).

Good luck and as always, create our world :)

