################################################################################
#
# westeros
#
################################################################################
WESTEROS_VERSION = 23a65d1fa48f6d82d51c3cb6cd08bf403f95187d
WESTEROS_SITE_METHOD = git
WESTEROS_SITE = https://github.com/rdkcmf/westeros
WESTEROS_INSTALL_STAGING = YES

WESTEROS_DEPENDENCIES = host-pkgconf host-autoconf wayland \
	libxkbcommon westeros-simpleshell westeros-simplebuffer westeros-soc

WESTEROS_CONF_OPTS = \
	--prefix=/usr/ \
	--enable-rendergl=yes \
	--enable-sbprotocol=yes \
	--enable-ldbprotocol=yes \
	--enable-xdgv5=yes \
	--enable-app=yes \
	--enable-test=yes \
	--enable-player=yes

ifeq ($(BR2_PACKAGE_WESTEROS_ESSOS), y)
WESTEROS_CONF_OPTS += \
	--enable-essos=yes
else
WESTEROS_CONF_OPTS += \
	--enable-essos=no
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
	WESTEROS_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -DWESTEROS_PLATFORM_RPI -DWESTEROS_INVERTED_Y -DBUILD_WAYLAND -I${STAGING_DIR}/usr/include/interface/vmcs_host/linux"
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
else ifeq ($(BR2_PACKAGE_LIBDRM),y)
	WESTEROS_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -DWESTEROS_PLATFORM_DRM"
	WESTEROS_CONF_ENV += LDFLAGS="-L$(@D)/.libs -lEGL -lGLESv2"
endif # BR2_PACKAGE_WESTEROS_SOC_RPI

ifeq ($(BR2_PACKAGE_HAS_NEXUS),y)
define WESTEROS_APPLY_BRCM_PATCHES
        patch -d $(@D)/ -p1 < package/westeros/1080.patch.brcm
endef
endif
WESTEROS_POST_PATCH_HOOKS += WESTEROS_APPLY_BRCM_PATCHES

define WESTEROS_RUN_AUTORECONF
        cd $(@D) && $(HOST_DIR)/usr/bin/autoreconf --force --install
endef
WESTEROS_PRE_CONFIGURE_HOOKS += WESTEROS_RUN_AUTORECONF

define WESTEROS_BUILD_CMDS
	SCANNER_TOOL=${HOST_DIR}/usr/bin/wayland-scanner \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/protocol
	SCANNER_TOOL=${HOST_DIR}/usr/bin/wayland-scanner \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/linux-dmabuf/protocol
	$(WESTEROS_MAKE_OPTS) \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(WESTEROS_LDFLAGS)
endef

define WESTEROS_INSTALL_STAGING_CMDS
	cp -a $(@D)/.libs/*.so* $(STAGING_DIR)/usr/lib/
	cp -a $(@D)/*.pc $(STAGING_DIR)/usr/lib/pkgconfig/
	cp -a $(@D)/*.h $(STAGING_DIR)/usr/include
	cp -a $(@D)/protocol/*.h $(STAGING_DIR)/usr/include
	cp -a $(@D)/essos/.libs/*.so* $(STAGING_DIR)/usr/lib/
	cp -a $(@D)/essos/essos*.h $(STAGING_DIR)/usr/include
endef

define WESTEROS_INSTALL_TARGET_CMDS
	cp -a $(@D)/.libs/*.so* $(TARGET_DIR)/usr/lib/
	cp -a $(@D)/essos/.libs/*.so* $(TARGET_DIR)/usr/lib/
endef

$(eval $(autotools-package))

include $(sort $(wildcard $(BR2_EXTERNAL_ML_OSS_PATH)/package/westeros/westeros-*/*.mk))
