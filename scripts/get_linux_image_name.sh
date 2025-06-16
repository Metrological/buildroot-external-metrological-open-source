get_linux_image_name() {
    local config="$1"
    # Custom image name logic
    if grep -q '^BR2_LINUX_KERNEL_IMAGE_TARGET_CUSTOM=y' "$config"; then
        local name
        name=$(grep '^BR2_LINUX_KERNEL_IMAGE_NAME=' "$config" | cut -d= -f2- | tr -d '"')
        if [ -n "$name" ]; then
            echo "$name"
            return
        fi
        name=$(grep '^BR2_LINUX_KERNEL_IMAGE_TARGET_NAME=' "$config" | cut -d= -f2- | tr -d '"')
        if [ -n "$name" ]; then
            echo "$name"
            return
        fi
    fi

    # Standard image types
    if grep -q '^BR2_LINUX_KERNEL_UIMAGE=y' "$config"; then
        echo "uImage"
    elif grep -q '^BR2_LINUX_KERNEL_APPENDED_UIMAGE=y' "$config"; then
        echo "uImage"
    elif grep -q '^BR2_LINUX_KERNEL_BZIMAGE=y' "$config"; then
        echo "bzImage"
    elif grep -q '^BR2_LINUX_KERNEL_ZIMAGE=y' "$config"; then
        echo "zImage"
    elif grep -q '^BR2_LINUX_KERNEL_ZIMAGE_EPAPR=y' "$config"; then
        echo "zImage.epapr"
    elif grep -q '^BR2_LINUX_KERNEL_APPENDED_ZIMAGE=y' "$config"; then
        echo "zImage"
    elif grep -q '^BR2_LINUX_KERNEL_CUIMAGE=y' "$config"; then
        # Needs DTS name, fallback to cuImage
        echo "cuImage"
    elif grep -q '^BR2_LINUX_KERNEL_SIMPLEIMAGE=y' "$config"; then
        echo "simpleImage"
    elif grep -q '^BR2_LINUX_KERNEL_IMAGE=y' "$config"; then
        echo "Image"
    elif grep -q '^BR2_LINUX_KERNEL_IMAGEGZ=y' "$config"; then
        echo "Image.gz"
    elif grep -q '^BR2_LINUX_KERNEL_LINUX_BIN=y' "$config"; then
        echo "linux.bin"
    elif grep -q '^BR2_LINUX_KERNEL_VMLINUX_BIN=y' "$config"; then
        echo "vmlinux.bin"
    elif grep -q '^BR2_LINUX_KERNEL_VMLINUX=y' "$config"; then
        echo "vmlinux"
    elif grep -q '^BR2_LINUX_KERNEL_VMLINUZ=y' "$config"; then
        echo "vmlinuz"
    elif grep -q '^BR2_LINUX_KERNEL_VMLINUZ_BIN=y' "$config"; then
        echo "vmlinuz.bin"
    else
        echo "ERROR: Could not determine LINUX_IMAGE_NAME from $config" >&2
        return 1
    fi
}
