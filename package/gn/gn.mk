################################################################################
#
# GN-build-system
#
################################################################################

HOST_GN_VERSION = df4a8e68510787e17f87cea99f6a8fe6227fd188
HOST_GN_SITE_METHOD = git
HOST_GN_SITE = https://cobalt.googlesource.com/third_party/gn
HOST_GN_INSTALL_STAGING = YES
HOST_GN_DEPENDENCIES = host-python3

define HOST_GN_BUILD_CMDS
    export CXX=g++; $(HOST_DIR)/usr/bin/python3 $(@D)/build/gen.py --no-last-commit-position
    $(HOST_DIR)/usr/bin/ninja -C $(@D)/out
endef

define HOST_GN_INSTALL_CMDS
    cp $(@D)/out/gn $(HOST_DIR)/usr/bin
endef

$(eval $(host-generic-package))
