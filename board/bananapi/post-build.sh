#!/usr/bin/env bash

# set -u
set -e
# set -x

BOARD_DIR="$(dirname "$0")"
USE_EXTLINUX=0

. "${BR2_EXTERNAL_ML_OSS_PATH}/scripts/get_linux_image_name.sh"

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
                --use-extlinux)
                USE_EXTLINUX=1
        esac
done

UBOOT_BOARD=$(eval grep ^BR2_TARGET_UBOOT_BOARD_DEFCONFIG= ${BR2_CONFIG} | cut -d '=' -f 2 | tr -d '"')

KERNEL=$(get_linux_image_name "${BR2_CONFIG}")

export

FILES=()
CUSTOM_BOOT_FILES=( )

if [ "${USE_EXTLINUX}" -eq 1 ]; then
    echo "Installing extlinux configuration for U-Boot board ${UBOOT_BOARD}"

    mkdir -pv "${BINARIES_DIR}/extlinux"

    sed -e "s|#KERNEL#|${KERNEL}|" \
        "${BOARD_DIR}/${UBOOT_BOARD}/extlinux.conf.in" > "${BINARIES_DIR}/extlinux/extlinux.conf"

    # Adding it to FILES array doen't work, because genimage.cfg copies the file to the root of the boot partition
    # Instead, we add the file with a custom path "source:destination"
    CUSTOM_BOOT_FILES+=( "extlinux/extlinux.conf:extlinux/extlinux.conf" )
else
   echo "Installing boot.src configuration for U-Boot board ${UBOOT_BOARD}"

   sed -e "s|#KERNEL#|${KERNEL}|" \
       "${BOARD_DIR}/${UBOOT_BOARD}/boot.cmd.in" > "${BINARIES_DIR}/boot.cmd" 

   NORMALIZED_ARCH=$(eval grep ^BR2_NORMALIZED_ARCH= ${BR2_CONFIG} | cut -d '=' -f 2 | tr -d '"')

   ${HOST_DIR}/usr/bin/mkimage -A ${NORMALIZED_ARCH} -T script -C none -d "${BINARIES_DIR}/boot.cmd" "${BINARIES_DIR}/boot.scr"

   FILES+=( "boot.scr" )
fi

FILES+=( "${KERNEL}" )

for i in "${BINARIES_DIR}"/*.dtb; do
    FILES+=( "${i#${BINARIES_DIR}/}" )
done

BOOT_FILES=$(printf '\\t\\t\\t"%s",\\n' "${FILES[@]}")

for pair in "${CUSTOM_BOOT_FILES[@]}"; do
    IFS=':' read -r src dst <<< "$pair"
    BOOT_FILE_LIST+=$(printf '\t\tfile %s { image = "%s"}\n' "$src" "$dst")
done

sed -e "s|#BOOT_FILES#|${BOOT_FILES}|" \
    -e "s|#BOOT_FILE_LIST#|${BOOT_FILE_LIST}|" \
    "${BOARD_DIR}/genimage.cfg.in" > "${BINARIES_DIR}/genimage.cfg" 
