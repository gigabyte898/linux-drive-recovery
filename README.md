# linux-drive-recovery
Bash script to automate process of running fsck and mounting corrupted drives

Made this for my work to recover damaged hard drives. Supports ext2, ext3, ext4, FAT16, FAT32, linux-swap. lvm2-pv, NTFS, MacOS Journaled (HFS+), and ExFat drives. It will list the drives, allow you to select the one you want, scan and repair it, and mount it to your system in /media/recovery. ExFat drives only support error checking, not repairing, due to the limitations of the exfatfsck package. All other listed filesystems are capable of repair. The software will prompt you to install any needed packages automatically if they are missing so you don't need to go dependency hunting

## How do I run this?
The script is pretty self contained, all you need to do is make it executable and running it. This can be done by navigating to the directory the file is located in and run the following:
```
sudo chmod 755 Recovery.sh
./Recovery.sh
```

###### Obligatory "Don't blame me if stuff gets broken". Feel free to mess with this, just respect the GNU Public License and notate you made changes if you publish a copy.
