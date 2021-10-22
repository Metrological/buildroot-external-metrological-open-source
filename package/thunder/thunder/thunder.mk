################################################################################
#
# thunder
#
################################################################################
THUNDER_VERSION = a4b363a49cf81084d2a10e27eeff46d519e37a6d 
THUNDER_SITE = $(call github,rdkcentral,Thunder,$(THUNDER_VERSION))
THUNDER_INSTALL_STAGING = YES
THUNDER_DEPENDENCIES = zlib $(call qstrip,$(BR2_PACKAGE_SDK_INSTALL)) host-thunder-tools

THUNDER_CONF_OPTS += -DBUILD_REFERENCE=$(THUNDER_VERSION) -DTREE_REFERENCE=$(shell $(GIT) rev-parse HEAD)
THUNDER_CONF_OPTS += -DPORT=$(BR2_PACKAGE_THUNDER_PORT)
THUNDER_CONF_OPTS += -DBINDING=$(BR2_PACKAGE_THUNDER_BIND)
THUNDER_CONF_OPTS += -DIDLE_TIME=$(BR2_PACKAGE_THUNDER_IDLE_TIME)
THUNDER_CONF_OPTS += -DPERSISTENT_PATH=$(BR2_PACKAGE_THUNDER_PERSISTENT_PATH)
THUNDER_CONF_OPTS += -DVOLATILE_PATH=$(BR2_PACKAGE_THUNDER_VOLATILE_PATH)
THUNDER_CONF_OPTS += -DDATA_PATH=$(BR2_PACKAGE_THUNDER_DATA_PATH)
THUNDER_CONF_OPTS += -DSYSTEM_PATH=$(BR2_PACKAGE_THUNDER_SYSTEM_PATH)
THUNDER_CONF_OPTS += -DPROXYSTUB_PATH=$(BR2_PACKAGE_THUNDER_PROXYSTUB_PATH)
THUNDER_CONF_OPTS += -DOOMADJUST=$(BR2_PACKAGE_THUNDER_OOM_ADJUST)
THUNDER_CONF_OPTS += -DHIDE_NON_EXTERNAL_SYMBOLS=OFF

# THUNDER_CONF_OPTS += -DWEBSERVER_PATH=
# THUNDER_CONF_OPTS += -DWEBSERVER_PORT=
# THUNDER_CONF_OPTS += -DCONFIG_INSTALL_PATH=
# THUNDER_CONF_OPTS += -DIPV6_SUPPORT=
# THUNDER_CONF_OPTS += -DPRIORITY=
# THUNDER_CONF_OPTS += -DPOLICY=
# THUNDER_CONF_OPTS += -DSTACKSIZE=

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
THUNDER_CONF_OPTS += \
       -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

ifeq ($(BR2_PACKAGE_THUNDER_EXCEPTIONS_ENABLE),y)
	THUNDER_CONF_OPTS += -DEXCEPTIONS_ENABLE=ON
else
	THUNDER_CONF_OPTS += -DEXCEPTIONS_ENABLE=OFF
endif

ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_DEBUG),y)
	THUNDER_CONF_OPTS += -DBUILD_TYPE=Debug
else ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_DEBUG_OPTIMIZED),y)
	THUNDER_CONF_OPTS += -DBUILD_TYPE=DebugOptimized
else ifeq ($( BR2_PACKAGE_THUNDER_BUILD_TYPE_RELEASE_WITH_SYMBOLS),y)
	THUNDER_CONF_OPTS += -DBUILD_TYPE=ReleaseSymbols
else ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_RELEASE),y)
	THUNDER_CONF_OPTS += -DBUILD_TYPE=Release
else ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_PRODUCTION),y)
	THUNDER_CONF_OPTS += -DBUILD_TYPE=Production
endif

ifeq ($(BR2_PACKAGE_THUNDER_WARNING_REPORTING), y)
THUNDER_CONF_OPTS += -DWARNING_REPORTING=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_EXCEPTION_CATCHING), y)
THUNDER_CONF_OPTS += -DEXCEPTION_CATCHING=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_PERFORMANCE_MONITOR), y)
THUNDER_CONF_OPTS += -DPERFORMANCE_MONITOR=ON
endif

ifneq ($(BR2_PACKAGE_THUNDER_TRACE_SETTINGS),"")
THUNDER_CONF_OPTS += -DTRACE_SETTINGS="$(call qstrip,$(BR2_PACKAGE_THUNDER_TRACE_SETTINGS))"
endif

ifneq ($(BR2_PACKAGE_THUNDER_SYSTEM_PREFIX),"")
THUNDER_CONF_OPTS += -DSYSTEM_PREFIX="$(call qstrip,$(BR2_PACKAGE_THUNDER_SYSTEM_PREFIX))"
endif

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS),y)
THUNDER_CONF_OPTS += -DBLUETOOTH_SUPPORT=ON -DBLUETOOTH=ON
THUNDER_DEPENDENCIES += bluez5_utils
endif

ifeq ($(BR2_PACKAGE_THUNDER_BLUETOOTH),y)
THUNDER_EXTERN_EVENTS += Bluetooth
endif

ifeq ($(BR2_PACKAGE_THUNDER_SECURE_SOCKET),y)
THUNDER_DEPENDENCIES += openssl
THUNDER_CONF_OPTS += -DSECURE_SOCKET=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_BROADCAST),y)
THUNDER_CONF_OPTS += -DBROADCAST=ON
ifeq ($(BR2_PACKAGE_THUNDER_BROADCAST_SI_PARSING),y)
THUNDER_CONF_OPTS += -DBROADCAST_SI_PARSING=ON
endif
endif

ifeq ($(BR2_PACKAGE_THUNDER_PROCESSCONTAINERS),y)
THUNDER_CONF_OPTS += -DPROCESSCONTAINERS=ON
ifeq ($(BR2_PACKAGE_THUNDER_PROCESSCONTAINERS_BACKEND_LXC),y)
THUNDER_CONF_OPTS += -DPROCESSCONTAINERS_LXC=ON
THUNDER_DEPENDENCIES += lxc
endif
ifeq ($(BR2_PACKAGE_THUNDER_PROCESSCONTAINERS_BACKEND_RUNC),y)
THUNDER_CONF_OPTS += -DPROCESSCONTAINERS_RUNC=ON
endif
ifeq ($(BR2_PACKAGE_THUNDER_PROCESSCONTAINERS_BACKEND_CRUN),y)
THUNDER_CONF_OPTS += -DPROCESSCONTAINERS_CRUN=ON
THUNDER_DEPENDENCIES += crun
endif
endif

ifeq ($(BR2_PACKAGE_THUNDER_VIRTUALINPUT),y)
THUNDER_CONF_OPTS += -DVIRTUALINPUT=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_PROVISIONING),y)
THUNDER_EXTERN_EVENTS += Provisioning
endif

ifeq ($(BR2_PACKAGE_THUNDER_LOCATIONSYNC),y)
THUNDER_EXTERN_EVENTS += Internet
THUNDER_EXTERN_EVENTS += Location
endif

ifeq ($(BR2_PACKAGE_THUNDER_TIMESYNC),y)
THUNDER_EXTERN_EVENTS += Time
endif

ifeq ($(BR2_PACKAGE_THUNDER_COMPOSITOR),y)
THUNDER_EXTERN_EVENTS += Platform
THUNDER_EXTERN_EVENTS += Graphics
endif

ifeq ($(BR2_PACKAGE_THUNDER_NETWORKCONTROL),y)
THUNDER_EXTERN_EVENTS += Network
endif

ifeq ($(BR2_PACKAGE_THUNDER_CDMI),y)
THUNDER_EXTERN_EVENTS += Decryption
endif

ifeq ($(BR2_PACKAGE_THUNDER_STREAMER),y)
PEFRAMEWORK_EXTERN_EVENTS += Streaming
endif

ifeq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER),y)
THUNDER_CONF_OPTS += -DPLUGIN_WEBKITBROWSER=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_WEBSERVER),y)
THUNDER_EXTERN_EVENTS += WebSource
THUNDER_CONF_OPTS += -DPLUGIN_WEBSERVER=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_ESPIAL),y)
THUNDER_CONF_OPTS += -DPLUGIN_ESPIAL=ON
endif

THUNDER_CONF_OPTS += -DEXTERN_EVENTS="${THUNDER_EXTERN_EVENTS}"

ifeq ($(BR2_PACKAGE_THUNDER_INSTALL_INITD_DEPRECATED),y)
ifeq ($(BR2_PACKAGE_THUNDER_NETWORKCONTROL),y)
define THUNDER_POST_TARGET_INITD
	mkdir -p $(TARGET_DIR)/etc/init.d
	$(INSTALL) -D -m 0755 $(THUNDER_PKGDIR)/S80WPEFramework $(TARGET_DIR)/etc/init.d/S40WPEFramework
endef
else
define THUNDER_POST_TARGET_INITD
	mkdir -p $(TARGET_DIR)/etc/init.d
	$(INSTALL) -D -m 0755 $(THUNDER_PKGDIR)/S80WPEFramework $(TARGET_DIR)/etc/init.d
endef
endif
else
define THUNDER_POST_TARGET_INITD
	mv $(TARGET_DIR)/etc/init.d/wpeframework $(TARGET_DIR)/etc/init.d/S40Thunder
endef
endif

define THUNDER_POST_TARGET_REMOVE_STAGING_ARTIFACTS
	mkdir -p $(TARGET_DIR)/etc/WPEFramework
	rm -rf $(TARGET_DIR)/usr/share/WPEFramework/cmake
endef

define THUNDER_POST_TARGET_REMOVE_HEADERS
	rm -rf $(TARGET_DIR)/usr/include/WPEFramework
endef

ifneq ($(BR2_PACKAGE_THUNDER_DISABLE_INITD),y)
THUNDER_POST_INSTALL_TARGET_HOOKS += THUNDER_POST_TARGET_INITD
endif

THUNDER_POST_INSTALL_TARGET_HOOKS += THUNDER_POST_TARGET_REMOVE_STAGING_ARTIFACTS
ifneq ($(BR2_PACKAGE_THUNDER_INSTALL_HEADERS),y)
THUNDER_POST_INSTALL_TARGET_HOOKS += THUNDER_POST_TARGET_REMOVE_HEADERS
endif

# Temporary fix for vss platforms
ifeq ($(BR2_PACKAGE_VSS_SDK_MOVE_GSTREAMER),y)
THUNDER_PKGDIR = "$(BR2_EXTERNAL_ML_CSS_PATH)/package/thunder/thunder"

define THUNDER_APPLY_LOCAL_PATCHES
 # this platform needs to run this gstreamer version parallel
 # to an older version.
 $(APPLY_PATCHES) $(@D) $(THUNDER_PKGDIR) 9999-link_to_wpe_gstreamer.patch.conditional
endef
THUNDER_POST_PATCH_HOOKS += THUNDER_APPLY_LOCAL_PATCHES
endif

$(eval $(cmake-package))
