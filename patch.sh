#!/bin/sh
echo "Create folder to /sdcard/autoboot"
mkdir /sdcard/autoboot
echo "copy boot.img to /sdcard/autoboot/boot.img"
dd if=/dev/block/bootdevice/by-name/boot of=/sdcard/autoboot/boot.img

echo "create file /sdcard/autoboot/autoboot.init.rc"
cat << EOF > /sdcard/autoboot/autoboot.init.rc
on charger
 setprop ro.bootmode "normal"
 setprop sys.powerctl "reboot"
EOF

echo "Starting patch on boot.img"
/data/adb/magisk/magiskboot unpack boot.img
/data/adb/magisk/magiskboot cpio ramdisk.cpio \
"mkdir 0700 overlay.d" \
"add 0700 overlay.d/autoboot.init.rc autoboot.init.rc"
/data/adb/magisk/magiskboot repack boot.img boot_patched_autoboot.img
/data/adb/magisk/magiskboot cleanup

echo "Flashing..."
dd if=/sdcard/autoboot/boot_patched_autoboot.img of=/dev/block/bootdevice/by-name/boot
echo "Done"
