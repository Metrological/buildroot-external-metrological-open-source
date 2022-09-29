################################################################################
#
# COBALT
#
################################################################################

COBALT_VERSION = 3ba98a48be9cc4d6a8cc04d74e85ca9f830e13ee
COBALT_SITE_METHOD = git
COBALT_SITE = git@github.com:Metrological/cobalt
COBALT_INSTALL_STAGING = YES
COBALT_DEPENDENCIES = gst1-plugins-good gst1-plugins-bad host-bison host-ninja wpeframework-clientlibraries

export COBALT_STAGING_DIR=$(STAGING_DIR)
export COBALT_TOOLCHAIN_PREFIX=$(TARGET_CROSS)
export COBALT_INSTALL_DIR=$(TARGET_DIR)

export PATH := $(HOST_DIR)/bin:$(HOST_DIR)/usr/bin:$(HOST_DIR)/usr/sbin:$(PATH)

ifeq ($(BR2_PACKAGE_HAS_NEXUS),y)
# TODO: we might also have mips here at some point.
COBALT_PLATFORM = wpe-brcm-arm
COBALT_DEPENDENCIES += gst1-bcm
else
ifeq ($(BR2_ARCH_IS_64),y)
COBALT_PLATFORM = wpe-rpi64
else
COBALT_PLATFORM = wpe-rpi
endif

endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_CDM),y)
export COBALT_HAS_OCDM=1
else
export COBALT_HAS_OCDM=0
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PROVISIONPROXY),y)
export COBALT_HAS_PROVISION=1
else
export COBALT_HAS_PROVISION=0
endif

ifeq ($(BR2_PACKAGE_WESTON),y)
export COBALT_HAS_WAYLANDSINK=1
COBALT_DEPENDENCIES += weston
else
export COBALT_HAS_WAYLANDSINK=0
endif

ifeq ($(BR2_PACKAGE_COBALT_BUILD_TYPE_QA),y)
	COBALT_BUILD_TYPE = qa
	COBALT_DEPENDENCIES += host-nodejs
else ifeq ($(BR2_PACKAGE_COBALT_BUILD_TYPE_GOLD),y)
	COBALT_BUILD_TYPE = gold
endif

ifeq ($(BR2_PACKAGE_COBALT_IMAGE_AS_LIB), y)
export COBALT_EXECUTABLE_TYPE = shared_library
else
export COBALT_EXECUTABLE_TYPE = executable
endif

ifeq ($(BR2_PACKAGE_COBALT_USE_WPEFRAMEWORK_DATA_PATH), y)
export COBALT_DATA_PATH = "$(subst ",,$(BR2_PACKAGE_WPEFRAMEWORK_DATA_PATH)")/Cobalt"
COBALT_DATA_INSTALL_PATH = $(TARGET_DIR)/$(COBALT_DATA_PATH)
COBALT_DATA_SRC_PATH = content/data/*
else
COBALT_DATA_INSTALL_PATH = $(TARGET_DIR)/usr/share/
COBALT_DATA_SRC_PATH = content
endif

define COBALT_BUILD_CMDS
    $(@D)/src/cobalt/build/gyp_cobalt -C $(COBALT_BUILD_TYPE) $(COBALT_PLATFORM)
    $(HOST_DIR)/usr/bin/ninja -C $(@D)/src/out/$(COBALT_PLATFORM)_$(COBALT_BUILD_TYPE) cobalt_deploy
endef

define COBALT_INSTALL_TARGET_CMDS
    mkdir -p $(COBALT_DATA_INSTALL_PATH)
    cp -a $(@D)/src/out/$(COBALT_PLATFORM)_$(COBALT_BUILD_TYPE)/$(COBALT_DATA_SRC_PATH) $(COBALT_DATA_INSTALL_PATH)
endef


$(eval $(generic-package))
