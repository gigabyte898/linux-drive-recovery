# linux-drive-recovery
Bash script to automate process of running fsck and mounting corrupted drives

Made this for my work to recover damaged hard drives. Supports ext2, ext3, ext4, FAT16, FAT32, linux-swap. lvm2-pv, NTFS, MacOS Journaled (HFS+), and ExFat drives. It will list the drives, allow you to select the one you want, scan and repair it, and mount it to your system in /media/recovery. ExFat drives only support error checking, not repairing, due to the limitations of the exfatfsck package. All other listed filesystems are capable of repair. The software will prompt you to install any needed packages automatically if they are missing so you don't need to go dependency hunting

Feel free to mess with this, just respect the GNU Public License and notate you made changes if you publish a copy. I'm not responsible for any further data loss. 
