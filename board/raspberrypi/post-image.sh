#!/bin/bash

set -e
set -x

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
BLUETOOTH=$(eval grep ^BR2_PACKAGE_THUNDER_BLUETOOTH=y ${BR2_CONFIG} | wc -l)
BT_USERSPACE=$(eval grep ^BR2_PACKAGE_THUNDER_BLUETOOTH_CHIP_CONTROL_USERSPACE=y ${BR2_CONFIG} | wc -l)
ARCH64=$(eval grep ^BR2_ARCH_IS_64=y ${BR2_CONFIG} | wc -l)

LINUX_KERNEL_IMAGE=$(eval grep ^BR2_LINUX_KERNEL_IMAGE=y ${BR2_CONFIG} | wc -l)
LINUX_KERNEL_ZIMAGE=$(eval grep ^BR2_LINUX_KERNEL_ZIMAGE=y ${BR2_CONFIG} | wc -l)
ROOTFS_INITRAMFS=$(eval grep ^BR2_TARGET_ROOTFS_INITRAMFS=y ${BR2_CONFIG} | wc -l)

if [ ${BLUETOOTH} -gt 0 ]; then
   if ! grep -qE '^enable_uart=1' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
      echo "Adding serial console to /dev/ttyS0 to config.txt."
      sed -i 's/ttyAMA0/ttyS0/g' "${BINARIES_DIR}/rpi-firmware/cmdline.txt"
      cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable serial console on GPIOs 14 and 15 (pins 8 and 10 on the 40-pin header)
enable_uart=1
__EOF__
   fi
fi

if [ ${BT_USERSPACE} -gt 0 ]; then
   if ! grep -qE '^dtparam=krnbt=off' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
        echo "Adding dtparam=krnbt=off to config.txt."
        cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Control the bluetooth chip in userspace
dtparam=krnbt=off
__EOF__
   fi
fi

if [ ${ARCH64} -gt 0 ]; then
   if ! grep -qE '^arm_64bit=1' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
      echo "Enable 64 bits kernel"
      cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# enable 64bits support
arm_64bit=1
__EOF__
   fi
fi

if [ ${LINUX_KERNEL_ZIMAGE} -gt 0 ]; then
   if ! grep -qE '^kernel=zImage' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
      echo "Enable 'zImage' kernel"
      sed -i '/^kernel=.*/d' "${BINARIES_DIR}/rpi-firmware/config.txt"
      cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

kernel=zImage
__EOF__
   fi
fi

if [ ${LINUX_KERNEL_IMAGE} -gt 0 ]; then
   if ! grep -qE '^kernel=Image' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
      echo "Enable 'Image' kernel"
      sed -i '/^kernel=.*/d' "${BINARIES_DIR}/rpi-firmware/config.txt"
      cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

kernel=Image
__EOF__
   fi
fi

for arg in "$@"
do
        case "${arg}" in
                --gpu_mem_256=*|--gpu_mem_512=*|--gpu_mem_1024=*)
                # Set GPU memory
                gpu_mem="${arg:2}"
                sed -e "/^${gpu_mem%=*}=/s,=.*,=${gpu_mem##*=}," -i "${BINARIES_DIR}/rpi-firmware/config.txt"
                ;;
                --start_file=*)
                # Set GPU firmware file
                start_file="${arg:2}"
                sed -e "/^${start_file%=*}=/s,=.*,=${start_file##*=}," -i "${BINARIES_DIR}/rpi-firmware/config.txt"
                ;;
                --fixup_file=*)
                # Set file to fix up GPU memory locations
                fixup_file="${arg:2}"
                sed -e "/^${fixup_file%=*}=/s,=.*,=${fixup_file##*=}," -i "${BINARIES_DIR}/rpi-firmware/config.txt"
                ;;
                --tvmode-720)
                if ! grep -qE '^hdmi_mode=4' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                    echo "Adding 'tvmode=720' to config.txt."
                    cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Force 720p
hdmi_group=1
hdmi_mode=4
__EOF__
                fi
                ;;
                --tvmode-1080)
                if ! grep -qE '^hdmi_mode=16' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                    echo "Adding 'tvmode=1080' to config.txt."
                    cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Force 1080p
hdmi_group=1
hdmi_mode=16
__EOF__
                fi
                ;;
                --overclock*)
                if ! grep -qE '^arm_freq=' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                    echo "Adding 'overclock' to config.txt."
                    cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Overclock
force_turbo=1
[pi0]
[pi0w]
[pi1]
[pi2]
arm_freq=1000
gpu_freq=500
sdram_freq=500
over_voltage=6
[pi3]
arm_freq=1350
gpu_freq=500
sdram_freq=500
over_voltage=5
[pi3+]
arm_freq=1350
gpu_freq=500
sdram_freq=500
over_voltage=5
[all]
avoid_warnings=1
__EOF__
                fi
                ;;
                --add-vc4-fkms-v3d-overlay)
                # Enable VC4 overlay
                if ! grep -qE '^dtoverlay=vc4-fkms-v3d' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                        echo "Adding 'dtoverlay=vc4-fkms-v3d' to config.txt."
                        cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable DRM VC4 V3D driver
dtoverlay=vc4-fkms-v3d
__EOF__
                fi
                ;;
                --add-vc4-kms-v3d-overlay)
                # Enable VC4 overlay
                if ! grep -qE '^dtoverlay=vc4-kms-v3d' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                        echo "Adding 'dtoverlay=vc4-kms-v3d' to config.txt."
                        cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable DRM VC4 V3D driver
dtoverlay=vc4-kms-v3d
max_framebuffers=2
__EOF__
                fi
                ;;
                --silent)
                if ! grep -qE '^disable_splash=1' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                        echo "Adding 'silent=1' to config.txt."
                        cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Silent
disable_splash=1
boot_delay=0
__EOF__
                fi
                ;;
                --i2c)
                if ! grep -qE '^dtparam=i2c_arm=on' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                        echo "Adding 'i2c' functionality to config.txt."
                        cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable i2c functionality
dtparam=i2c_arm=on,i2c_arm_baudrate=400000
dtparam=i2c1=on,i2c1_baudrate=50000
__EOF__
                fi
                ;;
                --spi)
                if ! grep -qE '^dtparam=spi=on' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                        echo "Adding 'spi' functionality to config.txt."
                        cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable spi functionality
dtparam=spi=on
dtoverlay=spi0-1cs
__EOF__
                fi
                ;;
                --1w)
                if ! grep -qE '^dtoverlay=w1-gpio' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                        echo "Adding '1w' functionality to config.txt."
                        cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable 1Wire functionality
dtoverlay=w1-gpio,gpiopin=25
__EOF__
                fi
                ;;
                --add-miniuart-bt-overlay)
                if [ ${BLUETOOTH} -eq 0 ]; then
                        if ! grep -qE '^dtoverlay=miniuart-bt' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                                echo "Adding 'dtoverlay=miniuart-bt' to config.txt (fixes ttyAMA0 serial console)."
                                cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enables (3B, 3B+, 3A+, 4B and Zero W) serial console on ttyAMA0 
dtoverlay=miniuart-bt
__EOF__
                        fi
                fi
                ;;
                --rpi-wifi*)
                if [ "x${KERNEL_4_14}" = "x" ]; then
                        if ! grep -qE '^dtoverlay=sdtweak' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                                echo "Adding 'rpi wifi' functionality to config.txt."
                                cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable overlay for wifi functionality
dtoverlay=sdtweak,overclock_50=80
__EOF__
                        fi
                        if grep -qE '^dtoverlay=mmc' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                                echo "Removing overlay for mmc due to wifi compatibilityin config.txt."
                                cat "${BINARIES_DIR}/rpi-firmware/config.txt" | sed '/^# Enable mmc by default/,+2d' > "${BINARIES_DIR}/rpi-firmware/config_.txt"
                                rm "${BINARIES_DIR}/rpi-firmware/config.txt"
                                mv "${BINARIES_DIR}/rpi-firmware/config_.txt" "${BINARIES_DIR}/rpi-firmware/config.txt"
                        fi
                fi
                ;;
                --no-wifi)
                if ! grep -qE '^dtoverlay=disable-wifi' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                        echo "Adding 'dtoverlay=disable-wifi' to config.txt."
                        cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable overlay to disable onboard wifi
dtoverlay=disable-wifi
__EOF__
                fi
                ;;
                --no-bt)
                if ! grep -qE '^dtoverlay=disable-bt' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                        echo "Adding 'dtoverlay=disable-bt' to config.txt."
                        cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable overlay to disable onboard bluetooth
dtoverlay=disable-bt
__EOF__
                fi
                ;;
                --add-dtparam-audio)
                if ! grep -qE '^dtparam=audio=on' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                        echo "Adding 'dtparam=audio=on' to config.txt."
                        cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable onboard ALSA audio
dtparam=audio=on
__EOF__
                fi
                ;;
                --add-dtparam-krnbt-off)
                if ! grep -qE '^dtparam=krnbt=off' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
                        echo "Adding 'dtparam=audio=on' to config.txt."
                        cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Control the bluetooth chip via the BluetoothControl
dtparam=krnbt=off
__EOF__
                fi
                ;;
        esac

done

# generate genimage from template if a board specific variant doesn't exists
if [ ! -e "${GENIMAGE_CFG}" ]; then
	GENIMAGE_CFG="${BINARIES_DIR}/genimage.cfg"
	FILES=()

	for i in "${BINARIES_DIR}"/*.dtb "${BINARIES_DIR}"/rpi-firmware/*; do
		FILES+=( "${i#${BINARIES_DIR}/}" )
	done

	KERNEL=$(sed -n 's/^kernel=//p' "${BINARIES_DIR}/rpi-firmware/config.txt")
	FILES+=( "${KERNEL}" )

	BOOT_FILES=$(printf '\\t\\t\\t"%s",\\n' "${FILES[@]}")
	sed "s|#BOOT_FILES#|${BOOT_FILES}|" "${BOARD_DIR}/genimage.cfg.in" \
		> "${GENIMAGE_CFG}"
fi

# Pass an empty rootpath. genimage makes a full copy of the given rootpath to
# ${GENIMAGE_TMP}/root so passing TARGET_DIR would be a waste of time and disk
# space. We don't rely on genimage to build the rootfs image, just to insert a
# pre-built one in the disk image.

if grep "^BR2_TARGET_ROOTFS_EXT2=y$" "${BR2_CONFIG}" &>/dev/null; then 

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

rm -rf "${GENIMAGE_TMP}"

genimage \
        --rootpath "${ROOTPATH_TMP}"   \
        --tmppath "${GENIMAGE_TMP}"    \
        --inputpath "${BINARIES_DIR}"  \
        --outputpath "${BINARIES_DIR}" \
        --config "${GENIMAGE_CFG}"
fi

exit $?
