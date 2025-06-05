################################################################################
#
# westeros
#
################################################################################
WESTEROS_VERSION = b3533c1d5d7401f7ba96e2410a7fa1d8b12ce08e
WESTEROS_SITE_METHOD = git
WESTEROS_SITE = https://code.rdkcentral.com/r/components/opensource/westeros
WESTEROS_INSTALL_STAGING = YES
WESTEROS_AUTORECONF = YES
WESTEROS_DEPENDENCIES = host-pkgconf host-autoconf wayland libxkbcommon westeros-soc

define WESTEROS_GENERATE_WAYLAND_PROTOCOLS
	SCANNER_TOOL=${HOST_DIR}/usr/bin/wayland-scanner $(TARGET_MAKE_ENV) $(MAKE) -C $(1)
endef

define WESTEROS_GENERATE_DMABUF_PROTOCOLS
	$(call WESTEROS_GENERATE_WAYLAND_PROTOCOLS,$(@D)/linux-dmabuf/protocol)
endef

define WESTEROS_GENERATE_EXPSYNC_PROTOCOLS
	$(call WESTEROS_GENERATE_WAYLAND_PROTOCOLS,$(@D)/linux-expsync/protocol)
endef

define WESTEROS_GENERATE_XDG_PROTOCOLS
	$(call WESTEROS_GENERATE_WAYLAND_PROTOCOLS,$(@D)/protocol)
endef

ifeq ($(BR2_PACKAGE_WESTEROS_APPS),y)
WESTEROS_CONF_OPTS += \
	--enable-player=yes \
	--enable-app=yes \
	--enable-test=yes
endif

ifeq ($(BR2_PACKAGE_WESTEROS_ESSOS), y)
	WESTEROS_CONF_OPTS += --enable-essos=yes
else
	WESTEROS_CONF_OPTS += --enable-essos=no
endif

ifeq ($(BR2_PACKAGE_WESTEROS_RENDERER_GL),y)
	WESTEROS_CONF_OPTS += --enable-rendergl=yes
else
	WESTEROS_CONF_OPTS += --enable-rendergl=no
endif

ifeq ($(BR2_PACKAGE_WESTEROS_EMBEDDED_COMPOSITOR),y)
	WESTEROS_CONF_OPTS += --enable-embedded=yes
else
	WESTEROS_CONF_OPTS += --enable-embedded=no
endif

ifeq ($(BR2_PACKAGE_WESTEROS_MODULES),y)
	WESTEROS_CONF_OPTS += --enable-modules=yes
else
	WESTEROS_CONF_OPTS += --enable-modules=no
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
	WESTEROS_EXTRA_CFLAGS += CXXFLAGS="$(TARGET_CXXFLAGS) -DWESTEROS_PLATFORM_RPI -DWESTEROS_INVERTED_Y -DBUILD_WAYLAND -I${STAGING_DIR}/usr/include/interface/vmcs_host/linux"
	WESTEROS_LDFLAGS += -lEGL -lGLESv2 -lbcm_host
else ifeq ($(BR2_PACKAGE_HAS_NEXUS),y)
	WESTEROS_CONF_ENV += \
		PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR) 
	WESTEROS_CONF_OPTS += \
		--enable-vc5=yes \
		CFLAGS="$(TARGET_CFLAGS) -I${STAGING_DIR}/usr/include/refsw/" \
		CXXFLAGS="$(TARGET_CXXFLAGS) -I${STAGING_DIR}/usr/include/refsw/"
	WESTEROS_MAKE_OPTS += \
		PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR) \
		$(BCM_REFSW_MAKE_ENV)	
	WESTEROS_DEPENDENCIES += wayland-egl-bnxs bcm-refsw
endif 

ifeq ($(BR2_PACKAGE_WESTEROS_SIMPLE_PROTOCOL),y)
	WESTEROS_CONF_OPTS += --enable-sbprotocol=yes 
	WESTEROS_DEPENDENCIES += westeros-simpleshell westeros-simplebuffer
endif

ifeq ($(BR2_PACKAGE_WESTEROS_DMA_BUF_PROTOCOL),y)
	WESTEROS_CONF_OPTS += --enable-ldbprotocol=yes
	WESTEROS_PRE_BUILD_HOOKS += WESTEROS_GENERATE_DMABUF_PROTOCOLS

	ifeq ($(BR2_PACKAGE_LIBDRM),y)
		WESTEROS_CONF_OPTS += --enable-libdrm=yes
		WESTEROS_DEPENDENCIES += libdrm
	endif

	ifeq ($(BR2_PACKAGE_HAS_LIBGBM),y)
		WESTEROS_CONF_OPTS += --enable-gbm-modifiers=yes
		WESTEROS_DEPENDENCIES += libgbm
	endif
endif

ifeq ($(BR2_PACKAGE_WESTEROS_EXPSYNC_PROTOCOL),y)
	WESTEROS_CONF_OPTS += --enable-expsync=yes
	WESTEROS_PRE_BUILD_HOOKS += WESTEROS_GENERATE_EXPSYNC_PROTOCOLS
endif

ifeq ($(BR2_PACKAGE_WESTEROS_HAS_XDG_SHELL),y)
	WESTEROS_PRE_BUILD_HOOKS += WESTEROS_GENERATE_XDG_PROTOCOLS

	ifeq ($(BR2_PACKAGE_WESTEROS_XDG_SHELL_PROTOCOL_V5),y)
		WESTEROS_CONF_OPTS += --enable-xdgv5=yes
	else ifeq ($(BR2_PACKAGE_WESTEROS_XDG_PROTOCOL_SHELL_V4),y)
		WESTEROS_CONF_OPTS +=  --enable-xdgv4=yes
	else ifeq ($(BR2_PACKAGE_WESTEROS_XDG_PROTOCOL_SHELL_STABLE),y)
		WESTEROS_CONF_OPTS += --enable-xdgstable=yes
	endif
endif

ifeq ($(BR2_PACKAGE_HAS_NEXUS),y)
define WESTEROS_APPLY_BRCM_PATCHES
        patch -d $(@D)/ -p1 < $(BR2_EXTERNAL_ML_OSS_PATH)/package/westeros/patches/1080.patch.brcm
endef
endif
WESTEROS_POST_PATCH_HOOKS += WESTEROS_APPLY_BRCM_PATCHES

define WESTEROS_APPLY_PID_LOG_PATCH
    patch -d $(@D)/ -p1 < $(BR2_EXTERNAL_ML_OSS_PATH)/package/westeros/patches/Add-PID-to-logging.patch
endef

WESTEROS_POST_PATCH_HOOKS += WESTEROS_APPLY_PID_LOG_PATCH

$(eval $(autotools-package))

include $(sort $(wildcard $(BR2_EXTERNAL_ML_OSS_PATH)/package/westeros/westeros-*/*.mk))
