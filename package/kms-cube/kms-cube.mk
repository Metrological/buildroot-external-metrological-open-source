################################################################################
#
# kms-cube
#
################################################################################
KMS_CUBE_VERSION = 9f63f359fab1b5d8e862508e4e51c9dfe339ccb0
KMS_CUBE_SITE = https://gitlab.freedesktop.org/mesa/kmscube/-/archive/$(KMS_CUBE_VERSION)
KMS_CUBE_LICENSE = MIT
KMS_CUBE_LICENSE_FILES = COPYING
KMS_CUBE_DEPENDENCIES = host-pkgconf host-patchelf libdrm libegl libgbm libgles 

$(eval $(meson-package))
