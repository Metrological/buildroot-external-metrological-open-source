
ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_LIBGBM),y)
GST1_PLUGINS_BASE_WINSYS_LIST += gbm
GST1_PLUGINS_BASE_DEPENDENCIES += libgbm libgudev
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_LIBEGL),y)
GST1_PLUGINS_BASE_WINSYS_LIST += egl
endif
