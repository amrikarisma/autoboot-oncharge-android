# Autoboot On Charge for Android
How to enable automatic booting of your Android device when it's connected to a charger or USB.

### Requirements
- Rooted by Magisk
- Backup boot.img before start

### Patch & Flash
Connect to ADB shell and run the following commands:
```
mkdir /sdcard/autoboot
dd if=/dev/block/bootdevice/by-name/boot of=/sdcard/autoboot/boot.img
```
Create file auto boot on same folder with boot.img
```
nano /sdcard/autoboot/autoboot.init.rc
```
Then enter the script below:
```
on charger
 setprop ro.bootmode "normal"
 setprop sys.powerctl "reboot"
```
Execute the following commands:
```
/data/adb/magisk/magiskboot unpack boot.img
/data/adb/magisk/magiskboot cpio ramdisk.cpio \
"mkdir 0700 overlay.d" \
"add 0700 overlay.d/autoboot.init.rc autoboot.init.rc"
/data/adb/magisk/magiskboot repack boot.img boot_patched_autoboot.img
/data/adb/magisk/magiskboot cleanup
```
Flashing patch to boot.img. Run the following commands:
```
dd if=/sdcard/autoboot/boot_patched_autoboot.img of=/dev/block/bootdevice/by-name/boot
````

### Done
Power off your device and connect it to a charger or USB. Your device should boot automatically.

### Tested
- Redmi 4x
- Redmi Note 4
- soon

### Credits
https://github.com/anasfanani/magisk-autoboot
