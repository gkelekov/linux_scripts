# Automatic preseed ISO Debian builder
# 
# Script is for running preseed (unattended) instalation of only Debian LXDE 9.5, but it can easly be changed to suit 
# all other Debian/Ubuntu distributions.
# This script will open iso file, inject preseed configuration, inject any changes to grub2, and build new iso file.
#
# Script needs to be in same folder as "debian-lxde.iso" (download it from internet and rename it, or change $file2 name),
# and have subfolder "config". Config folder needs to have "preseed.cfg", "splash.png" and "menu.cfg" (preseed present 
# with script, splash.png and menu.cfg are extracted from grub installer, and can be changes, or if not needed do not 
# put spalsh.png and menu.cfg files within "config" subdirectory and no changes will be made during build)
# If you do not need creation of bootable USB stick (just ISO for VBox or VMWare), you can comment out or ignore lines 150 onwards.

### General settings
path=$PWD
file1="preseed.cfg"
file2="debian-lxde.iso"
file2=$1
name=$2
dir=minus5
f1p="$path/$dir/$file1"
f2p="$path/$file2"


### Set of functions
function prepare {
	printf "Install necessary packages..."\n
    	apt-get install bsdtar; apt-get install syslinux-utils;
	printf "\n"
}

function dots {
    sleep 1; printf " ."; sleep 1; printf "."; sleep 1; printf "."
}

function don {
    printf "       [ DONE ]\n"
}

function name () {
	read -p "Enter the name of build ISO file : " name
	read -p "Confirm $name file name with Y(es)? " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
		read -p "Enter new name of build ISO file : " name
		read -p "Confirm $name file name with Y(es) or push any other button to cancel build?" -n 1 -r
		if [[ ! $REPLY =~ ^[Yy]$ ]]
		then
			printf "\nExiting build...\n"
			[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
		else return $name 
		fi
	else
	#declare -n ret=$1
    	local rtn_msg=$name
    	ret=$rtn_msg 
fi
}

function usb () {
        read -p "Find your USB stick location and add it via keyboard: (like /dev/sdc)" usb
        read -p "Confirm $usb file name with Y(es)? " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]
        then
                read -p "Enter your USB stick location : " usb
                read -p "Confirm $usb file name with Y(es)" -n 1 -r
                if [[ ! $REPLY =~ ^[Yy]$ ]]
                then
                        printf "\nExiting installing to USB...\n"
                        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
                else return $usb
                fi
        else
        #declare -n ret=$1
        local rtn_msg=$usb
        ret=$n_msg
	echo $n_msg
fi
}

### Main
if [[ -f "$f1p" && -f "$file2" ]]
then
	printf "STARTING ISO BUILD by Minus5\n\nChecking necessary packages...\n"
	prepare
	printf "\n$file1 and $file2 found.\nStarting building iso with preseed.\n============================================================\n\n"
	#name
	printf $f1p
	#printf $2
	printf "\n"
	printf "Unpacking iso file"
	dots
	mkdir -p $path/iso
	bsdtar -C $path/iso -xf $path/$file2
	sleep 1
	don
	printf "Injecting new grub file"
	dots
	rm -r $path/iso/boot/grub/grub.cfg
	cp $path/config/grub.cfg $path/iso/boot/grub/grub.cfg
	rm -r $path/iso/isolinux/splash.png
	cp $path/config/splash.png $path/iso/isolinux/splash.png
	rm -r $path/iso/isolinux/menu.cfg
        cp $path/config/menu.cfg $path/iso/isolinux/menu.cfg
	don
	printf "Setting rights"
	dots
	chmod +w -R $path/iso/d-i/
	don
	printf "Unpacking initrd"
	dots
	gunzip $path/iso/d-i/initrd.gz
	don
	printf "Injecting "
	cd $path/$dir
	echo preseed.cfg | cpio -H newc -o -A -F $path/iso/d-i/initrd
	printf "Adding preseed configuration"
	dots
	don
	printf "Packaging initrd"
	dots
	gzip $path/iso/d-i/initrd
	sleep 1
	chmod -w -R $path/iso/d-i/
	don
	printf "Adding md5 checksum"
	dots
	md5sum `find -follow -type f` > md5sum.txt
	don
	cd $path
	printf "Building new iso file"
	genisoimage -r -J -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o $name.iso iso
	printf "Export iso file"
	dots
	don
	printf "Converting with "
	isohybrid $name.iso
	printf "Starting ISOHyberid"
	dots
	don
	sleep 2
	printf "Doing some cleaning"
	dots
	rm -r -f $path/iso
	rm -r -f md5*
	don
	sleep 1 
	printf "\nISO build complete...\n"
	printf "Your file $name.iso is located at $path directory.\n"
	printf "\n"
	printf "Prepare for building to USB stick"
	printf "Here is you current disk setup:\n"
	printf $fdisk
	printf "\n"
	usb
	printf "Installing to UBS stick"
	dd if=$name of=$ret
	printf "Runing DD"
	dots
	don
	printf "\n"
	printf "Your USB stick is now ready."

else
	printf "ERROR: $file1 or $file2 are missing. These files are mandatory for build.\nPlease add them to same directory as build.sh, and try again...\n"
	exit 0
fi
