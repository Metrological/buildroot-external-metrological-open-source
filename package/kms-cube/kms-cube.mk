################################################################################
#
# kms-cube
#
################################################################################

KMS_CUBE_VERSION = 4660a7dca6512b6e658759d00cff7d4ad2a2059d
KMS_CUBE_SITE = https://gitlab.freedesktop.org/mesa/kmscube/-/archive/$(KMSCUBE_VERSION)
KMS_CUBE_LICENSE = MIT
KMS_CUBE_LICENSE_FILES = COPYING
KMS_CUBE_DEPENDENCIES = host-pkgconf libdrm host-patchelf

#hack to remove a local path from the NEEDED list
define KMS_CUBE_FIX_NEEDED
     $(HOST_DIR)/usr/bin/patchelf --replace-needed $(STAGING_DIR)/usr/lib/libgbm.so libgbm.so $(@D)/build/kmscube
     $(HOST_DIR)/usr/bin/patchelf --replace-needed $(STAGING_DIR)/usr/lib/libgbm.so libgbm.so $(@D)/build/texturator
endef

KMS_CUBE_POST_BUILD_HOOKS += KMS_CUBE_FIX_NEEDED

$(eval $(meson-package))
