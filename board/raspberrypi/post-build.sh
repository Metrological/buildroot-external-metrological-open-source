#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

if grep -q "^BR2_TARGET_ROOTFS_INITRAMFS=y$" "${BR2_CONFIG}"; then

mkdir -p "${TARGET_DIR}/boot"
grep -q '^/dev/mmcblk0p1' "${TARGET_DIR}/etc/fstab" || \
    echo '/dev/mmcblk0p1 /boot vfat defaults 0 0' >> "${TARGET_DIR}/etc/fstab"

mkdir -p "${TARGET_DIR}/root"
grep -q '^/dev/mmcblk0p2' "${TARGET_DIR}/etc/fstab" || \
    echo '/dev/mmcblk0p2 /root ext4 defaults 0 0' >> "${TARGET_DIR}/etc/fstab"

fi

# libepoxy expects libGLESv2.so.2 and libEGL.so.1 to be present  
if grep -q "^BR2_PACKAGE_LIBEPOXY=y$" "${BR2_CONFIG}"; then
if ! [ -f ${TARGET_DIR}/usr/lib/libGLESv2.so.2 ]; then
    ln -sf libGLESv2.so ${TARGET_DIR}/usr/lib/libGLESv2.so.2 
fi

if ! [ -f ${TARGET_DIR}/usr/lib/libEGL.so.1 ]; then
    ln -sf libEGL.so ${TARGET_DIR}/usr/lib/libEGL.so.1 
fi
fi