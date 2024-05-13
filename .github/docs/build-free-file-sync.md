# build-FreeFileSync-on-raspberry-pi
FreeFileSync is a great open source file synchronization tool.
Building from source on linux is straightfoward *if* all the necessary dependencies are installed.
These instruction capture the necessary steps for installing the various dependencies and compiling FreeFileSync on 32-bit Raspberry Pi OS (formerly referred to as Raspbian)

These instructions are applicable to the following versions:

Item  | Release/Version
------------ | -------------
32 Bit Raspberry Pi OS (Raspbian) | Linux raspberrypi 6.1.21-v7+ #1642 SMP Mon Apr  3 17:20:52 BST 2023 armv7l GNU/Linux (from ```uname -a```)
FreeFileSync | ```v13.2```

## 1. Download and extract the FreeFilesSync source code

As of this writing, the latest version of FreeFileSync is 13.2 and it can be downloaded from:

https://freefilesync.org/download/FreeFileSync_13.2_Source.zip

Move the .zip file to the desired directory and uncompress
```unzip FreeFileSync_13.2_Source.zip```

## 2. Install available dependencies via apt-get
These instructions reflect building FreeFileSync using libgtk-3 but using libgtk-3 may lead to a non-optimal user experience- see:
https://freefilesync.org/forum/viewtopic.php?t=7660#p26057

The following dependencies need to be installed to compile:
- libgtk-3-dev
- libxtst-dev
- libssh2-1-dev

```
sudo apt-get update
sudo apt-get install libgtk-3-dev
sudo apt-get install libxtst-dev
sudo apt-get install libssh2-1-dev
```

## 3. Compile dependencies not available via apt-get

The following dependencies could not be installed via `apt-get` and need to be compiled from their source code.

### 3.1 gcc w/ good C++20 support

FreeFileSync requires good support of the C++20 standard and often takes advantage of the latest refinements once available across the major compilers (see https://freefilesync.org/vision.php for some background). As such, if you want to compile FreeFileSync on Raspberry Pi OS, you'll need a fresh version of gcc (the default version of gcc with RaspberyPi OS will not have all the necessary support).

For FFS v13.2, you'll need at least gcc 12.1.0

Follow the instruction at: https://www.raspberrypi.org/forums/viewtopic.php?t=239609 to build and install the gcc 12.1.0 with minor modifications. See [build_gcc.sh](build_gcc.sh) for the script with only C/C++ languages enabled. Before running, be sure to review and update the config in [build_gcc.sh](build_gcc.sh) according to your device (default is Raspberry Pi 4).

Note the build needs about 8 GB of free disk space and takes about **4 hours** on the **Raspberry Pi 4 (4 GB)**, **over 6 hours** on the **Raspberry Pi 3B+** and **over 50 hours** on the **Raspberry Pi Zero**.

```
sudo chmod +x build_gcc.sh
sudo bash build_gcc.sh
```

If you follow the steps correctly, you should see the new version:
```
g++ --version
```

Expected result:
```
g++ (GCC) 12.1.0
```

To ensure FreeFileSync can find the necessary libraries during runtime, copy the newly created libstdc++ lib to a standard Raspberry Pi OS location
```
sudo cp /usr/local/lib/libstdc++.so.6.0.30 /lib/arm-linux-gnueabihf/
sudo ldconfig
```

### 3.2 openssl

Starting with FreeFileSync 11.14, use of openssl 3.0 is supported so build OpenSSL 3.0 and make it available to use.
```
wget https://www.openssl.org/source/openssl-3.0.0.tar.gz
tar xvf openssl-3.0.0.tar.gz
cd openssl-3.0.0
mkdir build
cd build
../config
make
sudo make install
sudo ldconfig
```

### 3.3 libcurl
Starting with FreeFileSync v13.2, the minimum curl version (that provides the needed libcurl library) needed is 8.4

Acquire, build and install with the following steps:
```
wget https://curl.se/download/curl-8.4.0.tar.gz
tar xvf curl-8.4.0.tar.gz
cd curl-8.4.0/
mkdir build
cd build/
../configure --with-openssl --with-libssh2 --enable-versioned-symbols
make
sudo make install
```
Perform additional step so that the newly created libcurl libraries get put into the appropriate place for 32-bit RaspberryPi OS
```
sudo cp /usr/local/lib/libcurl.so.4.8.0 /usr/lib/arm-linux-gnueabihf/
sudo ldconfig
```

### 3.4 wxWidgets
Starting with FreeFileSync v13.2, the minimum version for WxWidgets is 3.2.3.

Build instructions are:
```
wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.3/wxWidgets-3.2.3.tar.bz2
tar xvf wxWidgets-3.2.3.tar.bz2
cd wxWidgets-3.2.3/
mkdir gtk-build
cd gtk-build/
../configure --disable-shared --enable-unicode --enable-no_exceptions
make
sudo make install
```
The need to disable WxWidget exception handling (using the '--enable-no_exceptions' options) was mentioned with the introduction of FFSv13.2 in the forums at:
https://freefilesync.org/forum/viewtopic.php?t=10794
If exceptions are enable on wxWidgets, FreeFileSync code could be modified to remove the check or to throw a warning instead of an error.

## 4. Tweak FreeFileSync code

In additional to providing the dependencies, some code tweaks are needed (see Bugs.txt in the top-level directory for a complete reference)

### 4.1 FreeFileSync/Source/afs/sftp.cpp

Add these constant definitions starting at line 21
```
#define MAX_SFTP_OUTGOING_SIZE 30000
#define MAX_SFTP_READ_SIZE 30000
```

### 4.2 Update FreeFileSync/Source/Makefile to use GTK3 instead of GTK2
While previously mentioned, use of GTK3 can result in poor UI experience (see thread at: https://freefilesync.org/forum/viewtopic.php?t=7660) the various dependencies for GTK2 building became too arduous for me on Raspbery Pi OS and so, picking my poison, I switched to GTK3 by doing the following:

On line 20:
```
change: cxxFlags  += `pkg-config --cflags gtk+-2.0`
to:     cxxFlags  += `pkg-config --cflags gtk+-3.0`
```

On line 22:
```
change: cxxFlags  += -isystem/usr/include/gtk-2.0
to:     cxxFlags  += -isystem/usr/include/gtk-3.0
```
### 4.3 [Optional] Populate Google client_id and client_key in Freefilesync/Source/afs/gdrive.cpp
Information about Google Drive support on self-compiled instances was mentioned at https://freefilesync.org/forum/viewtopic.php?t=8171

To set up and use a google cloud location for syncing, your compiled version of Free File Sync needs to be registered with Google (you can't reuse the registration credentials of the official FreeFileSync release for a number of reasons perhaps most fundamentally, you could modify the code in any shape/way/form and no longer use it as the original author intended)

The good news is that Google allows users to set up their own Google project with its own Client ID and Client Secret (free for personal testing/use). Once you get your own application registered, add the provided information in between the " " on lines 92 and 93:
```
std::string getGdriveClientId    () { return ""; } // => replace with live credentials
std::string getGdriveClientSecret() { return ""; } //
```

## 5. Compile in FreefileSync/Source directory

Run ```make``` in the folder FreeFileSync/Source.

Assuming the command completed without fatal errors, the binary should be waiting for you in FreeFileSync/Build/Bin.

## 6. Run FreeFileSync
Go to the FreeFileSync/Build/Bin directory and enter:
```
./FreeFileSync_armv7l
```

# Running FreeFileSync on another Raspberry Pi {UNTESTED/UNVERIFIED since v11.19}
You don't need to build anything again on the other Raspberry Pi hosts but you will need to copy over the various libraries and other dependencies so the executable can run.
Compilation made and tested on Raspberry Pi 4 w/4GB RAM using clean updated Raspberry Pi OS on 22 Nov 2020

## 1. Create zip file with executable and all dependencies
Once the executable binary has been created and verified working, copy all dependency libraries to the same folder as the binary, then copy the `Build/Resources` folder, then zip them all up in a file.

The shared libraries that need to be copied are:
- libssl.so.3
- libstdc++.so.6
- libcurl.so.4
- libgcc_s.so.1
- libcrypto.so.3
- libssh2.so.1


Then end zip file should look like this:
```
Archive:  FreeFileSync_11.4_armv7l.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2020-04-27 22:38   Bin/
  9074216  2020-04-27 22:35   Bin/FreeFileSync_armv7l
   560412  2020-04-17 13:40   Bin/libssl.so.3
 17574572  2020-04-10 15:12   Bin/libstdc++.so.6
   492832  2020-04-17 14:14   Bin/libcurl.so.4
  7543332  2020-04-10 15:10   Bin/libgcc_s.so.1
  3476740  2020-04-17 13:40   Bin/libcrypto.so.3
   961484  2020-04-17 14:07   Bin/libssh2.so.1
      349  2020-03-18 21:57   FreeFileSync.desktop
        0  2020-03-18 21:57   Resources/
      234  2020-03-18 21:57   Resources/Gtk3Styles.css
    12402  2020-03-18 21:57   Resources/RealTimeSync.png
   182060  2020-03-18 21:57   Resources/harp.wav
    87678  2020-03-18 21:57   Resources/bell2.wav
    13232  2020-03-18 21:57   Resources/FreeFileSync.png
   223687  2020-03-18 21:57   Resources/cacert.pem
      440  2020-03-18 21:57   Resources/Gtk2Styles.rc
    67340  2020-03-18 21:57   Resources/ding.wav
   143370  2020-03-18 21:57   Resources/bell.wav
   230274  2020-03-18 21:57   Resources/gong.wav
   388959  2020-03-18 21:57   Resources/Icons.zip
   522150  2020-03-18 21:57   Resources/Languages.zip
    55006  2020-03-18 21:57   Resources/notify.wav
```

Now the zip file should contain all the dependencies and the binary `Bin/FreeFileSync_armv7l` is able to run on a new raspberry pi assuming the target is running a current verions of Raspbian.


## 2. On target host, copy and extract the zip archive you created
extract to:
```
/home/pi/Desktop/FFS_11.4_ARM/
```

## 3. Copy all lib* files to /usr/lib

```
sudo cp /home/pi/Desktop/FFS_11.4_ARM/Bin/lib* /usr/lib
sudo ldconfig
```

## 4. Run FreeFileSync
Go to /home/pi/Desktop/FFS_11.4_ARM/Bin/
```
./FreeFileSync_armv7l
```

# Troubleshooting & Known Issues

##  Image used in 'About' diaglog is missing
When opening the 'About' dialog, a reference image file is missing. The lack of image generates an error but doesn't seem to have any other impact.
The issue seems to have been reported at:
https://freefilesync.org/forum/viewtopic.php?t=9444


## Error due to missing shared libraries
> *./FreeFileSync_armv7l: error while loading shared libraries: libssl.so.3: cannot open shared object file: No such file or directory*

```
sudo cp /home/pi/Desktop/FFS_11.3_ARM/Bin/lib* /usr/lib
sudo ldconfig
```

## Other issues could exist
Other issues could certainly exist as overall usage of FreeFileSync on Raspberry Pi is presumably small. It seems likely there could be issues with the more demanding or complex use-cases.
