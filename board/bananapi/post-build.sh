#!/bin/sh

set -u
set -e
set -x

BOARD_DIR="$(dirname "$0")"

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
                
                --ttyS0-console)
                # Enable a console on ttyS0 (serialport)
                if [ -e ${TARGET_DIR}/etc/inittab ]; then
                    echo "Enable Serial S0 console"
                    grep -qE '^ttyS0::' ${TARGET_DIR}/etc/inittab || \
                    sed -i '/GENERIC_SERIAL/a\
ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100 # ttyS0 console' ${TARGET_DIR}/etc/inittab
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
                --install-ssh-id)
                if [ ! -e ${BINARIES_DIR}/debug-access ]; then
                        echo "Generated Debug SSH ID"
                        ssh-keygen -q -t ed25519 -C "thunder@debug.access" -N "" -f "${BINARIES_DIR}/debug-access" 
                fi

                if [ ! -d ${TARGET_DIR}/etc/dropbear ]; then
                        echo "Fix dropbear folder"
                        rm -rf ${TARGET_DIR}/etc/dropbear 
                        mkdir -p ${TARGET_DIR}/etc/dropbear 
                fi

                if [ ! -e ${TARGET_DIR}/root/.ssh ]; then
                        echo "Fix .ssh folder"
                        ln -sf ../etc/dropbear ${TARGET_DIR}/root/.ssh 
                fi

                if [ -d ${TARGET_DIR}/etc/dropbear ] && [ -e ${BINARIES_DIR}/debug-access.pub ]; then
                        echo "Installing SSH debug key"
                        pubkey="$(cat ${BINARIES_DIR}/debug-access.pub)"

                        touch "${TARGET_DIR}/etc/dropbear/authorized_keys"
                        
                        if ! grep -q "${pubkey}" "${TARGET_DIR}/etc/dropbear/authorized_keys"; then
                                echo "Adding public key ${pubkey}"
                                echo ${pubkey} >> ${TARGET_DIR}/etc/dropbear/authorized_keys
                        fi
                fi
                ;;
        esac
done

install -m 666 -D "${BOARD_DIR}"/extlinux-$(basename ${BOARD_DIR}).conf "${TARGET_DIR}"/boot/extlinux/extlinux.conf
