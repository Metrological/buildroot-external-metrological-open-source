#!/bin/sh

set -u
set -e

for arg in "$@"
do
        case "${arg}" in
                --hdmi-console)
                # Enable a console on tty1 (HDMI)
                if [ -e ${TARGET_DIR}/etc/inittab ]; then
                    echo "Enable HDMI console"
                    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
                    sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
                fi
                ;;

                --mount-boot)
                # Enable mounting of the first partion to /boot
                if [ -e ${TARGET_DIR}/etc/inittab ]; then
                    echo "Enable mounting boot partion"
                    mkdir -p "${TARGET_DIR}/boot"
                    grep -q '^/dev/mmcblk0p1' "${TARGET_DIR}/etc/fstab" || \
                        echo '/dev/mmcblk0p1 /boot vfat defaults 0 0' >> "${TARGET_DIR}/etc/fstab"
                fi
                ;;
        esac
done

if grep -q "^BR2_TARGET_ROOTFS_INITRAMFS=y$" "${BR2_CONFIG}"; then

mkdir -p "${TARGET_DIR}/boot"
grep -q '^/dev/mmcblk0p1' "${TARGET_DIR}/etc/fstab" || \
    echo '/dev/mmcblk0p1 /boot vfat defaults 0 0' >> "${TARGET_DIR}/etc/fstab"

mkdir -p "${TARGET_DIR}/root"
grep -q '^/dev/mmcblk0p2' "${TARGET_DIR}/etc/fstab" || \
    echo '/dev/mmcblk0p2 /root ext4 defaults 0 0' >> "${TARGET_DIR}/etc/fstab"

fi
