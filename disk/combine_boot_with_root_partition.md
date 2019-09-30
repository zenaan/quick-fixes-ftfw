# Debian/Ubuntu/etc move (combine) /boot partition to / root partition

So old habits had a /boot partition and a / root partition, with /boot a measely ~300MiB, and
some kernels failing to boot on an old Lenovo Thinkpad X200 (Intel Core Duo 2640M).

One kernel is booting but there is no room on /boot to put another as it is filled with a second
"stable" kernel already (non booting). In hindsight it's obvious that if /boot is gonna be on a
separate partition, minimum size should be e.g. a couple GiB.

Solution for small /boot partition: combine /boot onto the / root partition, configure and
update/ reinstall `grub` bootloader so it knows the new partition layout.

Problem: `umount /boot` for the running system gives "`umount: /boot: target is busy.`"
Grub needs to know about the /boot directory, and install files (for example its menu) into that
directory hierarchy.

Solution: `mount --bind / /mnt`

Now we can look at the / root partition without any sub-mounts cluttering things up, and we see
`/mnt/boot` is empty.  So now we can `cp -a /boot/* /mnt/boot/` or to catch any dot files or dot
dirs, use `rsync` and in either case, delete any files from sub-mounts mounted inside `/boot`.

## Commands

Procedure is as follows - tested on Debian sid amd64 arch, 20190929 - just insert the
correct drive letter (usually not a partition) on the grub-install line below:

```sh
sudo su -                       # run the following commands as root
mount --bind / /mnt
test -e /mnt/boot/grub && exit  # if /mnt/boot not empty, you're on your own :)
rsync -av --exclude={'/lost+found/','/efi/*'} /boot/ /mnt/boot/

edit /etc/fstab                 # comment out the "/boot" entry, but leave /boot/efi as is
edit /etc/default/grub          # double check this

# Set up our /mnt chroot for grub-install to work properly, then update-grub + grub-install:
for i in boot/efi sys proc dev dev/pts run; do mount --bind /$i /mnt/$i; done
chroot /mnt /bin/bash -il       # login to temporary env for grub
update-grub                     # create new grub.cfg (Grub menu)
edit /mnt/boot/grub/grub.cfg    # have a look see
grub-install /dev/sdX           # magical incantation - choose correct drive here (usually 'sda')
# If all goes well, at this point you should see the following output (without "#"):
# Installing for x86_64-efi platform.
# Installation finished. No error reported.

# Clean up:
exit                            # exit from chroot
for i in run dev/pts dev proc sys boot/efi; do umount /mnt/$i; done
umount /mnt
reboot                          # reboot and hope it works...
```

**_Note:_** Regarding the `chroot` command above, the `-il` option to bash ensures that .profile
and/ or .bashrc are read/processed by Bash; it may be useful and/or prudent to disclude the
`-il` options to Bash, and make do with a default prompt, so that it is abundantly clear to you
that you are not in a 'normal' login, but a chroot, which may help avoid mistakes.
Including the `$SHLVL` env var somewhere in your PS1 prompt may alternatively assist in a
similar way.

## See also
 - https://askubuntu.com/questions/3402/how-to-move-boot-and-root-partitions-to-another-drive
 - https://help.ubuntu.com/community/Grub2/Installing#Reinstalling_GRUB_2
 - fdisk -l /dev/sda
 - ls -l /dev/disk/by-id
 - ls -l /dev/disk/by-uuid
 - https://www.linuxquestions.org/questions/linux-software-2/grub2-moving-boot-to-separate-partition-909761/
