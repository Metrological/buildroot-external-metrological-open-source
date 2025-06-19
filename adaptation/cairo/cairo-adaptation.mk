ifeq ($(call version_ge, ${CAIRO_VERSION}, 1.17.8),1)
ifeq ($(BR2_PACKAGE_CAIRO_ENABLE_GLES_BACKEND),y)
CAIRO_CONF_OPTS += -Dgl-backend=auto -Dglesv2=enabled -Dglesv3=auto

# CAIRO_DEPENDENCIES += libgles
# If GLES backend is enabled, we need to ensure that the libgles
# is built, before cairo is configured.
# but adding libgles to CAIRO_DEPENDENCIES will not work 
# because the dependeies make rules are already defined.
define CAIRO_ENSURE_EGL_DEPENDECIES_ARE_BUILD
    @$(call MESSAGE,"Ensuring libgles is built")
    $(MAKE) -C $(BASE_DIR) libgles
endef
CAIRO_PRE_CONFIGURE_HOOKS += CAIRO_ENSURE_EGL_DEPENDECIES_ARE_BUILD

# If GLES backend is enabled, we need to patch cairo to revert the commit
define CAIRO_PATCH_GLES_BACKEND
	@$(call MESSAGE,"Returning GLES backend support for cairo ${CAIRO_VERSION}")
	$(APPLY_PATCHES) $(@D) $(BR2_EXTERNAL_ML_OSS_PATH)/adaptation/cairo 0001-Add-support-for-OpenGL-surfaces-in-Cairo.patch
endef
CAIRO_POST_PATCH_HOOKS += CAIRO_PATCH_GLES_BACKEND

CAIRO_FINAL_ALL_DEPENDENCIES += libgles

endif
endif