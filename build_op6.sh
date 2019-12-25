#!/bin/bash

# Path to build your kernel
  k=~/kernel/op6tq
# Directory for the any kernel updater
  t=$k/packages
# Date to add to zip
  today=$(date +"%m_%d_%Y")

# Clean old builds
make O=out mrproper

# Setup the build
 cd $k/arch/arm64/configs/BBKconfigs
    for c in *
      do
        cd $k
# Setup output directory
    mkdir -p "out/$c"
    cp -R "$t/META-INF" out/$c
    cp -R "$t/tools" out/$c
    cp -R "$t/anykernel.sh" out/$c

  m=$k/out/$c/system/lib/modules
  z=$c-$today

#TOOLCHAIN=/home/forrest/kernel/aarch64-linux-android-4.9/bin/aarch64-linux-android-
#TOOLCHAIN=/home/forrest/kernel/gcc8.2/bin/aarch64-cortex_a75-linux-android-
#TOOLCHAIN=/home/forrest/kernel/linaro8.2/bin/aarch64-linux-gnu-
#TOOLCHAIN=/home/forrest/kernel/linaro8.3/bin/aarch64-linux-gnu-
TOOLCHAIN=/home/forrest/kernel/linaro9.2/bin/aarch64-none-linux-gnu-
# export CROSS_COMPILE=/home/forrest/kernel/gcc4.9/bin/aarch64-linux-android-
export ARCH=arm64
export SUBARCH=arm64

# make kernel

make O=out CROSS_COMPILE=$TOOLCHAIN elite_defconfig
make O=out CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l`

# Grab zImage-dtb
#   echo ""
#   echo "<<>><<>>  Collecting modules <<>><<>>"
#   echo ""
#   for mo in $(find . -name "*.ko"); do
#		cp "${mo}" $m
   echo ""
   echo "<<>><<>>  Collecting Image.gz-dtb <<>><<>>"
   echo ""
   cp $k/out/arch/arm64/boot/Image.gz-dtb out/$c/Image.gz-dtb
   done
   
# Build Zip
#clear
   echo "Creating $z.zip"
     cd $k/out/$c/
       7z a -tzip -mx5 "$z.zip"
         mv $z.zip $k/out/$z.zip
# cp $k/out/$z.zip $db/$z.zip
#           rm -rf $k/out/$c
# Line below for debugging purposes,  uncomment to stop script after each config is run
#read this
#      done
