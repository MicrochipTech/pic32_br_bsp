# Microchip PIC32 Buildroot BSP

This project contains the PIC32 board support package which consists of:
* Default configuration and settings
* Cross compiler toolchain
* Kernel and bootloader configuration
* Tools for flashing first and second stage bootloaders
* Buildroot based userspace and kernel configuration

This BSP uses Buildroot to compile the bootloader, kernel, and root filesystem for a specific PIC32 Linux board.


## System Requirements

This BSP is tested on the following distributions:
* Ubuntu 12.04 LTS i386
* Ubuntu 12.04 LTS x86_64
* Ubuntu 14.04 LTS i386
* Ubuntu 14.04 LTS x86_64
* Fedora 22 x86_64
* Fedora 22 i386


### Install Ubuntu System Dependencies

Install the following system dependencies:
```sh
$ sudo apt-get install subversion build-essential bison flex gettext libncurses5-dev texinfo autoconf automake libtool mercurial git-core gperf gawk expat curl cvs libexpat-dev bzr
```

### Install Fedora System Dependencies

Install the following system dependencies as root:
```sh
$ yum install subversion make gcc gcc-c++ patch ncurses-devel bison flex gettext texinfo gawk bc autoconf automake libtool mercurial git gperf expat curl cvs bzr
```

## Build

The PIC32 BSP requires Buildroot version 2015.05 or newer.  We provide a known working version.

    $ git clone https://github.com/MicrochipTech/pic32_br_bsp.git
    $ git clone https://github.com/MicrochipTech/buildroot.git
    $ cd buildroot
    $ make BR2_EXTERNAL=../pic32_br_bsp/ pic32mzda_evk_defconfig
    $ make

The resulting bootloader, kernel, and root filesystem will be put in the 'output/images' directory.


### Optionally Configure Packages and Kernel

Userspace packages and the Linux kernel, for example, can be optionally selected and configured using Buildroot.

To configure userspace packages and re-build:
```sh
$ make menuconfig
$ make
```

To configure the kernel and re-build:
```sh
$ make linux-menuconfig
$ make
```

Create a list of software licenses used:
```sh
$ make legal-info
```

## Create Bootable uSD Card

A uSD card can be made manually with the artifacts from output/images, but it can also be done automatically with the included mksdcard script.  Insert a uSD card and run the script as root to automatically detect the removable device:

```sh
$ sudo ../pic32_br_bsp/board/microchip/scripts/mksdcard
```
or, to select a specific device node:

```sh
$ sudo ../pic32_br_bsp/board/microchip/scripts/mksdcard /dev/sdX
```

## Bootloader

The are two bootloaders: a first stage and second stage bootloader.  The second stage bootloader is u-boot.  The first stage bootloader is built using an MPLAB X project.  The same project is used to combine and flash the first and second stage bootloaders.

### Installing System Dependencies

Building and flashing the bootloader requires XC32 >= v1.410, MPLAB X >= v2015-08-10, and a MPLAB REAL ICE programmer.

### Building the Bootloader

```sh
$ make menuconfig
```

And make sure the following option is selected:

```text
-> User-provided options
   [*] PIC32 stage1 Bootloader
```

Then build.

```sh
$ make
```

The generated hex file will be put in output/images/.  This hex file includes both the first and second stage bootloaders.

### Flashing the Bootloader

The bootloaders can be flashed using a REAL ICE or by using the PKOB on the starter kit, based on the environment variable HWTOOL.

To flash using a REAL ICE:
1. Connect a MPLAB REAL ICE between a USB port on the host computer and the J4 connector on the evaluation kit. Make sure there is no jumper on J17 of the starter kit.

2. From the buildroot directory:

```sh
$ make flash HWTOOL=RealICE
```
3. The combined bootloader image will be written to the Boot and Program Flash memories of the PIC32 device.

To flash using the PKOB on the starter kit:
1. Connect a mini-USB cable between a USB port on the host computer and the DEBUG connector on the starter kit. Make sure there is a jumper on J17 of the starter kit.

2. From the buildroot directory:

```sh
$ make flash HWTOOL=sk
```
3. The combined bootloader image will be written to the Boot and Program Flash memories of the PIC32 device.

### Bootloader Flashing FAQ

**Problem**

When running `make bootloader_flash` the following message is displayed:

Reception on endpoint 1 failed (err = -150)
Connection Failed.
If the problem persists, please disconnect and reconnect the REAL ICE to the USB cable. If this does not fix the problem verify that the proper MPLAB X USB drivers have been installed.

**Solution**

Unplug the MPLAB REAL ICE from the PC and plug it back in.

**Problem**

When running `make bootloader_flash` the following message is displayed:

Target Device ID (0x5fff053) does not match expected Device ID (0x5f6a053).
Target Device ID (0x5fff053) does not match expected Device ID (0x5f6a053). Would you like to continue? [yes/no]

**Solution**

Enter y and hit enter.


## Related Links
* Microchip GitHub: https://github.com/microchiptech
* Buildroot documentation: http://nightly.buildroot.org/manual.html

