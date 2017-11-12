Read me file for Blackboard
---------------------------

Document sections:
 - Requirements
 - Download software
 - Build hardware
 - Load software
 - Test the board
 - Build SD card
 - Using Linux on Blackboard
 - Build new boot files

Requirements
------------
 - Vivado and XSDK 2017.1 loaded and operational.  Newer versions may work,
   but there may be some porting required.
 - Windows or Linux PC.  Building ofthe system has been tested on Windows.
 - 8 GByte microSD FLASH card to boot Linux.  It is recommended to use a
   Class 10 microSD card or better.  The system has been tested with a
   Kingston microSD card, part number SDCIT/8GB.  A larger microSD card
   can be used.
 - Edimax EW-7811Un Wi-Fi dongle for networking.

Download software
-----------------
1. Use "git clone" to copy the git repository from github to a local machine.

Build hardware
--------------
1. Bring up Xilinx Vivado.
2. Use "Tools->Run Tcl Script..." to run the script "xillydemo-vivado.tcl"
   in the "blockdesign" subdirectory.
3. Click the "Generate Bitstream" button on the lower-left column.  This
   will kick off the hardware synthesis, implementation, and generation
   of the bitstream.
4. After generation of the bitstream, export the design to the "sw" directory
   by selecting "File->Export->Export Hardware".  When the "Export Hardware"
   dialog comes up, make sure the "Include bitstream" box is checked and then
   select the "sw" subdirectory for "Export to".
5. Finally, select "File->Launch SDK" to bring up Xilinx SDK.  When the
   "Launch SDK" dialog comes up, select the "sw" subdirectory for both the
   "Exported location" and "Workspace".

Load software
-------------
1. When Xilinx SDK comes up, it will load in the exported files, which will
   take less than a minute.
2. Once loaded, select "File->Import..." from the menu to load in the existing
   projects.
3. From the Import dialog, select from the tree the
   "General->Existing Projects into Workspace" and click "Next".
4. For the root directory, browse to the "sw" subdirectory.
5. The Projects that will be loaded should already be checked.  Then click
   "Finish" to import the projects.  The import and build will take about
   a minute or so to complete.

Test the board
--------------
1. Connect a USB cable from the PC to J10 on the board.  You will need this
   cable connected as a minimum to test the board.
2. Make sure jumper JP2 is set for "JTAG" and jumper JP3 is set to "EXTP" if
   using an external USB power supply connected to J13.  If only using the
   USB connection to J10, select "USB" for JP3.  Turn on switch SW8.  If
   power is active, LED LD12 will light up in red.
3. You should now run a terminal emulator, like Teraterm or minicom to connect
   to the serial port that has been assigned to the board.  Once connected,
   output from the tests will be displayed in the main window of the terminal
   emulator program.
4. With the software projects built, the bit file can be downloaded to the
   FPGA.  To do this, select "Xilinx Tools->Program FPGA" from the menu.
   Then click the "Program" button in the "Program FPGA" dialog.  The green
   LED, LD11, near the 7-segment display should light up when programming
   completes.
5. The first test to try after programming the FPGA is the "memory_test".
   Right click on "memory_test" from the "Project Explorer" on the left side
   of the SDK.  Then select "Run As->Launch on Hardware (System Debugger)"
   from the drop-down menu.  This will download the memory test application
   to the board and runn it.  You should see all tests pass.
6. You can also run the "hello_world" application in a similar manner as
   described for the memory test program.  The hello world application runs
   from DDR3 memory whereas the memory test runs from FPGA SRAM.

Build SD card
-------------
1. Download the software image from:
     http://xillybus.com/downloads/xillinux-1.3.img.gz.
2. Decompress the image file.  On Linux, you can use:
   - "gunzip xillinux-1.3.img.gz"
   You can use WinZip to decompress the file in Windows.
3. The image needs to be burned onto the SD card.  For Linux you can use:
   - "dd if=xillinux-1.3.img of=/dev/diskX bs=512" where the X in diskX is
     replaced with the actual disk that represents the SD card.
   For Windows you can use imageUSB by PassMark Software.
   - Select the drive in "Step 1".
   - Select "Write image to USB drive" in "Step 2".
   - Browse to "xillinux-1.3.img" in "Step 3".
   - Then click the "Write" button.
4. Copy the following files from the "bootfiles" subdirectory to the
   first partition on the SD FLASH card:
   - BOOT.bin
   - devicetree.dtb
   - xillydemo.bit
   - rtlwifi.tar.gz (For USB Wi-Fi)
   These files have been pre-built and tested on a real board.  The file
   "uImage" should already be on the first partition after completing
   step 3 above.
5. Unmount (Linux) or eject (Windows) the SD card from the PC and then insert
   it into the "SD MICRO" slot on the board.
6. To boot Linux, make sure JP2 is set to "SD" and connect an external USB
   supply to J13.  Make sure JP3 is set to "EXTP".
7. Turn on SW8 to power-up the board.  Linux should boot with log messages
   being displayed on the main window of the terminal emulator.  See the
   Test section above for setting up a terminal emulator.
8. A USB hub with a keyboard and mouse can be plugged into J8 of the board
   To start an X windows session, type "startx" on the keyboard plugged
   into the Blackboard board.  X-Windows should start up in about a minute.

Using Linux on Blackboard
-------------------------
1. The partition size for the ext4 Linux partion is only about 1.7 GBytes in
   size.  To fully use the 8 GByte or bigger SD card, use fdisk to increase
   partition 2 to fully use all available sectors.  Once fdisk has been run,
   reboot Blackboard and then use the "resize2fs" utility to tell Linux to
   resize the partition.  Once complete, the ext4 partition should be over
   7 GBytes in size.
2. Update the /etc/fstab file to include the following lines:
# configured fstab for Blackboard
/dev/root       /               auto    defaults                1 1
none            /proc           proc    rw,noexec,nosuid,nodev  0 0
none            /sys            sysfs   rw,noexec,nosuid,nodev  0 0
devtmpfs        /dev            devtmpfs rw,mode=0755           0 0
devpts          /dev/pts        devpts  rw,noexec,nosuid,gid=5,mode=0620 0 0
/dev/mmcblk0p1  /mnt/boot       vfat    noauto                  0 0
/swapfile       none            swap    sw                      0 0
3. A swap file can be created that should provide a more stable Linux system
   when using a large number of programs or the X11 GUI.  To create a swap
   file use the following steps:
   - Create the swap file with
       "dd if=/dev/zero of=/swapfile bs=1024 count=1048576"
   - Initialize the swap file with "mkswap /swapfile"
   - Type "swapon -a" to mount the swap file.  You can see the status of
     the swap file by typing "swapon -s".
4. To bring up networking, plug in a USB network dongle or Wi-Fi dongle.
   For Wi-Fi, you will probably need to load some firmware files to the
   /lib/firemware directory.  For Realek drivers, you already copied them
   to the first partition of the SD card.  To move them to the /lib/firmware
   directory, perform the following steps:
   - Mount partion 1 by typing "mkdir /mnt/boot" and then "mount /mnt/boot".
   - Then switch to the /lib/firmware directory by typing "cd /lib/firmware".
   - Now copy in the firmware files by typing
       "tar xvzf /mnt/boot/rtlwifi.tar.gz ."
   - Plug in the Wi-Fi dongle to the USB hub.
   - From the X-Windows GUI, click on the "System Settings" icon located in
     the toolbar to the left.  Then click on Network in the "System Settings"
     window.
   - Select Wireless on the left side, type in the SSID for your Network Name.
   - In the next dialog select your network security, enter in the key, and
     then click "Connect".
   We have used an Edimax EW-7811Un Wi-Fi dongle successfully using the above
   steps.
5. With networking operational, you can update the Ubuntu software.  To do
   the upgrade, use the following steps:
   - Type "apt-get update" to fetch the latest metadata for Ubuntu.
   - Type "apt-get upgrade" to perform the actual update to the various
     packages installed on the system.
6. To install git on Blackboard, type "apt-get install git" from a terminal
   window.  Git will be used in the next section to build u-boot.

Build new boot files
--------------------
To build new boot files for the SD card, use the following steps:
1. To create a new BOOT.bin file, make sure steps 1 and 2 of the
   "Load software" section have been completed.  Then right-click on
   "fsbl_uboot" in the "Project Explorer" on the left hand side.
   Then select "Create Boot Image" from the drop-down menu.  This
   will display the "Create Boot Image" dialog.  Just click on the
   "Create Image" button at the bottom.  Once complete, you can copy
   the "BOOT.bin" file from the "sw/fsbl_uboot/bootimage" subdirectory
   to the first partition of the SD card.
2. To regenerate the "devicetree.dtb" file after editing the
   "xillinux-1.3-blackboard.dts" file, use the following command:
   - "dtc -I dts -O dtb -o devicetree.dtb xillinux-1.3-blackboard.dts"
   You can then copy the updated device tree to partition one of the SD card.
3. To recompile u-boot, that is part of the BOOT.bin file, you will need
   to clone "u-boot-xlnx" from our git repository.  Once cloned on your
   local PC, you can use the following steps to build the u-boot elf file:
   - "make zynq_blackboard_defconfig"
   - "make"
   The second step will take a while to complete.  Once build, you can copy
   the "u-boot" elf file in the "u-boot-xlnx" directory to
   "sw/fsbl_uboot/Debug/u-boot.elf" in "xillinux-eval-blackboard".  From
   there, follow step 1 above to create a new "BOOT.bin" file.
4. Instructions to build a new Linux kernel and place it in uImage will
   be added here at a future date.

