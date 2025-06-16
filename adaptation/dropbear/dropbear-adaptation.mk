ifeq ($(BR2_PACKAGE_DROPBEAR_LIBDROPBEAR_SUPPORT),y)
define DROPBEAR_INSTALL_LIBDROPBEAR
    @$(call MESSAGE, "Installing libdropbear")
    $(INSTALL) -D -m 644 $(@D)/libdropbear.a $(STAGING_DIR)/usr/lib/libdropbear.a
    $(INSTALL) -D -m 644 $(@D)/libdropbear.pc $(STAGING_DIR)/usr/lib/pkgconfig/libdropbear.pc
    $(INSTALL) -d $(STAGING_DIR)/usr/include/dropbear
    $(INSTALL) -m 644 $(@D)/*.h $(STAGING_DIR)/usr/include/dropbear
endef
DROPBEAR_POST_INSTALL_TARGET_HOOKS += DROPBEAR_INSTALL_LIBDROPBEAR

define DROPBEAR_BUILD_LIBDROPBEAR
    @$(call MESSAGE,"Building libdropbear")
    $(MAKE) -C $(@D) libdropbear.a libdropbear.pc
endef
DROPBEAR_POST_BUILD_HOOKS += DROPBEAR_BUILD_LIBDROPBEAR

define DROPBEAR_PATCH_LIBDROPBEAR
    @$(call MESSAGE,"Patching for libdropbear")
	$(APPLY_PATCHES) $(@D) $(BR2_EXTERNAL_ML_OSS_PATH)/adaptation/dropbear 0001-Add-pkg-config-support-and-enhance-session-managemen.patch
endef
DROPBEAR_POST_PATCH_HOOKS += DROPBEAR_PATCH_LIBDROPBEAR


endif
