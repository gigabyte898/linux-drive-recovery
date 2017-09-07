#!/bin/bash
#List disks
fdisk -l

#Ask user what disk is desired for recovery
echo 
echo
echo "Which disk and partition do you want? Enter the full path (/dev/sd..)"

#Capture user input to variable "$diskpath"
read -p "Enter path: " diskpath

#Check if filesystem requires other dependencies, store varibale answer as "$filesystem"
read -p "Is this hard drive from a Mac/formatted to HFS+? [y/n]" filesystemHFS

#Verify filesystem. If the filesystem is HFS+, ask if they have hfsprogs. If not, perform standard fsck check
case $filesystemHFS in
    [Yy]* ) read -p "Do you have hfsprogs? [y/n]" hfsprogsvar
            case $hfsprogsvar in
                #If hfsprogs is already installed, run fsck with hfsprogs modifier
                [Yy]* ) echo "Runnning fsck to verify and fix errors, please follow any following prompts that run with fsck"
                        sleep 3s
                        sudo fsck.hfsplus -f $diskpath ;;
                #If hfsprogs is not installed, ask if they want the program to install it
                [Nn]* ) read -p "hfsprogs is required to read/write MacOS Journaled drives, would you like me to install it for you? [y/n]" install
                        case $install in
                            #If yes, install hfsprogs and run fsck
                            [Yy]* ) sudo apt-get install hfsprogs 
                                    echo "Runnning fsck to verify and fix errors, please follow any following prompts that run with fsck"
                                    sleep 3s
                                    sudo fsck.hfsplus -f $diskpath ;;                                                                                                                                      
                            #If no, tell user they need hfsprogs and quit program                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                            [Nn]* ) echo "Please install hfsprogs"
                                    exit ;;
                        esac ;;
            esac ;;
    #Check if the filesystem is ExFat       
    [Nn]* ) read -p "Is this filesystem ExFat? [y/n]" filesystemExFat
            case $filesystemExFat in
                [Yy]* ) read -p "Do you have the required packages to read ExFat (exfat-fuse and exfatfsck)?" fuse
                        case $fuse in
                            #If the user has exfat-fuse and exfatfsck, run them
                            [Yy]* ) sudo exfatfsck $diskpath
                                    read -p "Do you see any errors in the output?" errors
                                    case $errors in
                                        [Yy]* ) echo "You need to repair this drive in Windows"
                                                exit;;
                                        [Nn]* ) ;;
                                    esac ;;
                            #If they user does not have the packages, install and run them
                            [Nn]* ) read -p "Do you want me to install the packages?" exfatInstall
                                    case $exfatInstall in
                                        [Yy]* ) sudo apt-get install exfat-fuse
                                                sudo apt-get install exfatfsck
                                                echo "Running file check"
                                                sleep 3s
                                                sudo exfatfsck $diskpath
                                                read -p "Do you see any errors in the output?" errors
                                                case $errors in
                                                    [Yy]* ) echo "You need to repair this drive in Windows"
                                                            exit  ;;
                                                    [Nn]* ) ;;
                                                esac ;;
                                        [Nn]* ) echo "You need the packages to check the filesystem and mount the drive, please install them and run this  utility again"
                                                exit ;;
                                    esac ;;
                        esac ;;
                #For any other filesystems that don't need other packages, run fsck
                [Nn]* ) echo "Runnning fsck to verify and fix errors, please follow any following prompts that run with fsck"
                        sudo fsck -f $drivepath ;;
            esac ;;
esac

#Inform user fsck completed and ask if it mounted
read -p "Hooray, fsck fixed your drive! Do you see the drive mounted? [y/n]" mounted

case $mounted in
    #If filesystem is mounted, exit program
    [Yy]* ) echo "You're all set, just transfer the data to the other drive"
            exit ;;
    #If the filesystem is not mounted, ask if they want to mount it
    [Nn]* ) read -p "Do you want me to mount it for you?" mountDrive
            case $mountDrive in
                #mount the drive then exit program
                [Yy]* ) echo "Mounting drive..."
                        sleep 3s
                        sudo mkdir /media/recovery
                        case $filesystemHFS in
                            [Yy]* ) sudo mount -t hfsplus -o force,rw $diskpath /media/recovery;;
                            [Nn}* ) sudo mount $diskpath /media/recovery;;
                        esac
                        echo "Drive has been mounted. If you still dont see it, navigate to 'Other Locations' in the file explorer or /media/recovery. Thanks for using my program!"
                        exit ;;
                #exit program
                [Nn]* ) echo "Thanks for using my program!"
                        exit ;;
            esac ;;
esac 
                
