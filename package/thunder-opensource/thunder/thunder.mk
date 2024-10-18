################################################################################
#
# thunder
#
################################################################################
THUNDER_VERSION = 62ffa21c683ba2dd076843b7f4d751997107720a
THUNDER_SITE = $(call github,rdkcentral,Thunder,$(THUNDER_VERSION))
THUNDER_INSTALL_STAGING = YES
THUNDER_DEPENDENCIES = zlib $(call qstrip,$(BR2_PACKAGE_SDK_INSTALL)) host-thunder-tools

THUNDER_TREE_REFERENCE := BR-$(BUILDROOT_REFERENCE)
ifeq ($(BUILDROOT_DIRTY),1)
THUNDER_TREE_REFERENCE := $(THUNDER_TREE_REFERENCE)-dirty
endif

THUNDER_TREE_REFERENCE := $(THUNDER_TREE_REFERENCE)_OSS-$(EXTERNAL_ML_OSS_REFERENCE)
ifeq ($(EXTERNAL_ML_OSS_DIRTY),1)
THUNDER_TREE_REFERENCE := $(THUNDER_TREE_REFERENCE)-dirty
endif

ifneq ($(EXTERNAL_ML_CSS_REFERENCE),)
THUNDER_TREE_REFERENCE := $(THUNDER_TREE_REFERENCE)_CSS-$(EXTERNAL_ML_CSS_REFERENCE)
ifeq ($(EXTERNAL_ML_CSS_DIRTY),1)
THUNDER_TREE_REFERENCE := $(THUNDER_TREE_REFERENCE)-dirty
endif
endif

# THUNDER_TREE_REFERENCE := $(THUNDER_TREE_REFERENCE);$(notdir $(call qstrip,$(BR2_DEFCONFIG)))

THUNDER_CONF_OPTS += -DBUILD_REFERENCE=$(THUNDER_VERSION) 
THUNDER_CONF_OPTS += -DTREE_REFERENCE="$(THUNDER_TREE_REFERENCE)"
THUNDER_CONF_OPTS += -DPORT=$(BR2_PACKAGE_THUNDER_PORT)
THUNDER_CONF_OPTS += -DBINDING=$(BR2_PACKAGE_THUNDER_BIND)
THUNDER_CONF_OPTS += -DIDLE_TIME=$(BR2_PACKAGE_THUNDER_IDLE_TIME)
THUNDER_CONF_OPTS += -DSOFT_KILL_CHECK_WAIT_TIME=$(BR2_PACKAGE_THUNDER_SOFT_KILL_CHECK_WAIT)
THUNDER_CONF_OPTS += -DHARD_KILL_CHECK_WAIT_TIME=$(BR2_PACKAGE_THUNDER_HARD_KILL_CHECK_WAIT)
THUNDER_CONF_OPTS += -DPERSISTENT_PATH=$(BR2_PACKAGE_THUNDER_PERSISTENT_PATH)
THUNDER_CONF_OPTS += -DVOLATILE_PATH=$(BR2_PACKAGE_THUNDER_VOLATILE_PATH)
THUNDER_CONF_OPTS += -DDATA_PATH=$(BR2_PACKAGE_THUNDER_DATA_PATH)
THUNDER_CONF_OPTS += -DSYSTEM_PATH=$(BR2_PACKAGE_THUNDER_SYSTEM_PATH)
THUNDER_CONF_OPTS += -DPROXYSTUB_PATH=$(BR2_PACKAGE_THUNDER_PROXYSTUB_PATH)
THUNDER_CONF_OPTS += -DOOMADJUST=$(BR2_PACKAGE_THUNDER_OOM_ADJUST)
THUNDER_CONF_OPTS += -DETHERNETCARD_NAME=$(BR2_PACKAGE_THUNDER_ETHERNETCARD_NAME)
THUNDER_CONF_OPTS += -DTRACING=OFF
THUNDER_CONF_OPTS += -DTOOLS_SYSROOT=${HOST_DIR}

# THUNDER_CONF_OPTS += -DWEBSERVER_PATH=
# THUNDER_CONF_OPTS += -DWEBSERVER_PORT=
# THUNDER_CONF_OPTS += -DCONFIG_INSTALL_PATH=
# THUNDER_CONF_OPTS += -DIPV6_SUPPORT=
# THUNDER_CONF_OPTS += -DPRIORITY=
# THUNDER_CONF_OPTS += -DPOLICY=
# THUNDER_CONF_OPTS += -DSTACKSIZE=

ifneq ($(BR2_PACKAGE_THUNDER_GROUP),"")
THUNDER_USER_STRING=- - $(subst ",,$(BR2_PACKAGE_THUNDER_GROUP)") -1 * - - - general $(subst ",,$(BR2_PACKAGE_THUNDER_GROUP)") group
THUNDER_USER_PERMISSION=$(subst ",,$(BR2_PACKAGE_THUNDER_INSTALL_PATH)") d 0550 root $(subst ",,$(BR2_PACKAGE_THUNDER_GROUP)") - - - - -
THUNDER_PERSISTENT_ROOT_PERMISSION=$(subst ",,$(BR2_PACKAGE_THUNDER_PERSISTENT_PATH)") d 0755 root root - - - - -
THUNDER_PERSISTENT_PERMISSION=$(subst ",,$(BR2_PACKAGE_THUNDER_PERSISTENT_PATH)/Thunder") d 0770 root $(subst ",,$(BR2_PACKAGE_THUNDER_GROUP)") - - - - -

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
		THUNDER_CONF_OPTS += -DPLATFORM_VIDEO_SUBSYSTEM=vchiq
	else
		THUNDER_CONF_OPTS += -DPLATFORM_VIDEO_SUBSYSTEM=drm
	endif

	THUNDER_CONF_OPTS += -DUDEV_VIDEO_RULE=ON
	THUNDER_CONF_OPTS += -DPLATFORM_VIDEO_DEVICE_GROUP=$(subst ",,$(BR2_PACKAGE_THUNDER_PLATFORM_VIDEO_DEVICE_GROUP)")
endif

ifeq ($(BR2_INIT_NONE),y)
	THUNDER_CONF_OPTS += -DSYSTEMD_SERVICE=OFF
	THUNDER_CONF_OPTS += -DINITV_SCRIPT=OFF
else ifeq ($(BR2_INIT_SYSTEMD),y)
	THUNDER_CONF_OPTS += -DSYSTEMD_SERVICE=ON
	THUNDER_CONF_OPTS += -DINITV_SCRIPT=OFF
else
	THUNDER_CONF_OPTS += -DINITV_SCRIPT=ON
	
	ifeq ($(BR2_PACKAGE_THUNDER_NETWORKCONTROL),y)
		THUNDER_CONF_OPTS += -DSYSV_INIT_LEVEL=40
	endif
endif

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
THUNDER_CONF_OPTS += \
       -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

ifeq ($(BR2_PACKAGE_THUNDER_DISABLE_LEGACY_CONFIG_GENERATOR),y)
	THUNDER_CONF_OPTS += -DLEGACY_CONFIG_GENERATOR=OFF
endif

ifeq ($(BR2_PACKAGE_THUNDER_HIDE_NON_EXTERNAL_SYMBOLS),y)
	THUNDER_CONF_OPTS += -DHIDE_NON_EXTERNAL_SYMBOLS=ON
else
	THUNDER_CONF_OPTS += -DHIDE_NON_EXTERNAL_SYMBOLS=OFF
endif

ifeq ($(BR2_PACKAGE_THUNDER_ENABLE_STRICT_COMPILER),y)
	THUNDER_CONF_OPTS += -DENABLE_STRICT_COMPILER_SETTINGS=ON
else
	THUNDER_CONF_OPTS += -DENABLE_STRICT_COMPILER_SETTINGS=OFF
endif

ifeq ($(BR2_PACKAGE_THUNDER_EXCEPTIONS_ENABLE),y)
	THUNDER_CONF_OPTS += -DEXCEPTIONS_ENABLE=ON
else
	THUNDER_CONF_OPTS += -DEXCEPTIONS_ENABLE=OFF
endif

ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_DEBUG),y)
	THUNDER_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
else ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_DEBUG_OPTIMIZED),y)
	THUNDER_CONF_OPTS += -DCMAKE_BUILD_TYPE=DebugOptimized
else ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_RELEASE_WITH_SYMBOLS),y)
	THUNDER_CONF_OPTS += -DCMAKE_BUILD_TYPE=RelWithDebInfo
else ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_RELEASE),y)
	THUNDER_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
else ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_PRODUCTION),y)
	THUNDER_CONF_OPTS += -DCMAKE_BUILD_TYPE=MinSizeRel
endif

ifeq ($(BR2_PACKAGE_THUNDER_TRACE_LEVEL_OFF),y)
	THUNDER_CONF_OPTS += -DDISABLE_TRACING=ON
else ifeq ($(BR2_PACKAGE_THUNDER_TRACE_LEVEL_1),y)
	THUNDER_CONF_OPTS += -DDISABLE_TRACING=OFF -DENABLED_TRACING_LEVEL=1
else ifeq ($(BR2_PACKAGE_THUNDER_TRACE_LEVEL_2),y)
	THUNDER_CONF_OPTS += -DDISABLE_TRACING=OFF -DENABLED_TRACING_LEVEL=2
else ifeq ($(BR2_PACKAGE_THUNDER_TRACE_LEVEL_3),y)
	THUNDER_CONF_OPTS += -DDISABLE_TRACING=OFF -DENABLED_TRACING_LEVEL=3
else ifeq ($(BR2_PACKAGE_THUNDER_TRACE_LEVEL_4),y)
	THUNDER_CONF_OPTS += -DDISABLE_TRACING=OFF -DENABLED_TRACING_LEVEL=4
else ifeq ($(BR2_PACKAGE_THUNDER_TRACE_LEVEL_5),y)
	THUNDER_CONF_OPTS += -DDISABLE_TRACING=OFF -DENABLED_TRACING_LEVEL=5
endif

ifneq ($(BR2_PACKAGE_THUNDER_TRACING_MODULES),)
THUNDER_CONF_OPTS += -DENABLE_TRACING_MODULES=$(BR2_PACKAGE_THUNDER_TRACING_MODULES)
endif

ifeq ($(BR2_PACKAGE_THUNDER_WARNING_REPORTING), y)
THUNDER_CONF_OPTS += -DWARNING_REPORTING=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_MESSAGING), y)
THUNDER_CONF_OPTS += -DMESSAGING=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_EXCEPTION_CATCHING), y)
THUNDER_CONF_OPTS += -DEXCEPTION_CATCHING=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_PERFORMANCE_MONITORING), y)
THUNDER_CONF_OPTS += -DPERFORMANCE_MONITOR=ON
endif

ifneq ($(BR2_PACKAGE_THUNDER_TRACE_SETTINGS),"")
THUNDER_CONF_OPTS += -DTRACE_SETTINGS="$(call qstrip,$(BR2_PACKAGE_THUNDER_TRACE_SETTINGS))"
endif

ifneq ($(BR2_PACKAGE_THUNDER_MESSAGE_SETTINGS),"")
THUNDER_CONF_OPTS += -DMESSAGE_SETTINGS="$(call qstrip,$(BR2_PACKAGE_THUNDER_MESSAGE_SETTINGS))"
endif

ifneq ($(BR2_PACKAGE_THUNDER_SYSTEM_PREFIX),"")
THUNDER_CONF_OPTS += -DSYSTEM_PREFIX="$(call qstrip,$(BR2_PACKAGE_THUNDER_SYSTEM_PREFIX))"
endif

ifneq ($(BR2_PACKAGE_THUNDER_UMASK),"")
THUNDER_CONF_OPTS += -DUMASK="$(call qstrip,$(BR2_PACKAGE_THUNDER_UMASK))"
endif

ifneq ($(BR2_PACKAGE_THUNDER_GROUP),"")
THUNDER_CONF_OPTS += -DGROUP="$(call qstrip,$(BR2_PACKAGE_THUNDER_GROUP))"
endif

ifeq ($(BR2_PACKAGE_THUNDER_BROADCAST),y)
THUNDER_CONF_OPTS += -DBROADCAST=ON
ifeq ($(BR2_PACKAGE_THUNDER_BROADCAST_SI_PARSING),y)
THUNDER_CONF_OPTS += -DBROADCAST_SI_PARSING=ON
endif
endif

ifeq ($(BR2_PACKAGE_THUNDER_BLUETOOTH),y)
THUNDER_CONF_OPTS += -DBLUETOOTH_SUPPORT=ON -DBLUETOOTH=ON
THUNDER_DEPENDENCIES += bluez5_utils-headers
ifeq ($(BR2_PACKAGE_BRCMFMAC_SDIO_FIRMWARE_RPI_BT)$(BR2_PACKAGE_THUNDER_BLUETOOTH_CHIP_CONTROL_USERSPACE),yy)
THUNDER_CONF_OPTS += -DBCM43XX=ON
endif
ifeq ($(BR2_PACKAGE_THUNDER_BLUETOOTH_GATT),y)
THUNDER_CONF_OPTS += -DBLUETOOTH_GATT_SUPPORT=ON
endif
ifeq ($(BR2_PACKAGE_THUNDER_BLUETOOTH_AUDIO),y)
THUNDER_CONF_OPTS += -DBLUETOOTH_AUDIO_SUPPORT=ON
THUNDER_DEPENDENCIES += sbc
endif
endif

ifeq ($(BR2_PACKAGE_THUNDER_EXTENSION_PRIVILEDGED_REQUEST),y)
THUNDER_CONF_OPTS += -DPRIVILEGEDREQUEST=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_EXTENSION_LOCALTRACER),y)
THUNDER_CONF_OPTS += -DLOCALTRACER=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_SECURE_SOCKET),y)
THUNDER_DEPENDENCIES += openssl
THUNDER_CONF_OPTS += -DSECURE_SOCKET=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_PROCESSCONTAINERS),y)
THUNDER_CONF_OPTS += -DPROCESSCONTAINERS=ON
ifeq ($(BR2_PACKAGE_THUNDER_PROCESSCONTAINERS_BE_LXC),y)
THUNDER_CONF_OPTS += -DPROCESSCONTAINERS_LXC=ON
THUNDER_DEPENDENCIES += lxc
endif
ifeq ($(BR2_PACKAGE_THUNDER_PROCESSCONTAINERS_BE_RUNC),y)
THUNDER_CONF_OPTS += -DPROCESSCONTAINERS_RUNC=ON
endif
ifeq ($(BR2_PACKAGE_THUNDER_PROCESSCONTAINERS_BE_CRUN),y)
THUNDER_CONF_OPTS += -DPROCESSCONTAINERS_CRUN=ON
THUNDER_DEPENDENCIES += crun
endif
endif

ifeq ($(BR2_PACKAGE_THUNDER_VIRTUALINPUT),y)
THUNDER_CONF_OPTS += -DVIRTUALINPUT=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER),y)
THUNDER_CONF_OPTS += -DPLUGIN_WEBKITBROWSER=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_WEBSERVER),y)
THUNDER_CONF_OPTS += -DPLUGIN_WEBSERVER=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_ESPIAL),y)
THUNDER_CONF_OPTS += -DPLUGIN_ESPIAL=ON
endif

define THUNDER_POST_TARGET_REMOVE_STAGING_ARTIFACTS
	mkdir -p $(TARGET_DIR)/etc/Thunder
	rm -rf $(TARGET_DIR)/usr/share/Thunder/cmake
endef

define THUNDER_POST_TARGET_REMOVE_HEADERS
	rm -rf $(TARGET_DIR)/usr/include/Thunder
endef

THUNDER_POST_INSTALL_TARGET_HOOKS += THUNDER_POST_TARGET_REMOVE_STAGING_ARTIFACTS
ifneq ($(BR2_PACKAGE_THUNDER_INSTALL_HEADERS),y)
THUNDER_POST_INSTALL_TARGET_HOOKS += THUNDER_POST_TARGET_REMOVE_HEADERS
endif

# Temporary fix for vss platforms
ifeq ($(BR2_PACKAGE_VSS_SDK_MOVE_GSTREAMER),y)
THUNDER_PKGDIR = "$(TOP_DIR)/package/wpe/thunder"

define THUNDER_APPLY_LOCAL_PATCHES
 # this platform needs to run this gstreamer version parallel
 # to an older version.
 $(APPLY_PATCHES) $(@D) $(THUNDER_PKGDIR) 9999-link_to_wpe_gstreamer.patch.conditional
endef
THUNDER_POST_PATCH_HOOKS += THUNDER_APPLY_LOCAL_PATCHES
endif

define THUNDER_USERS
	$(THUNDER_USER_STRING)
endef

define THUNDER_PERMISSIONS
	$(THUNDER_USER_PERMISSION)
	$(THUNDER_PERSISTENT_ROOT_PERMISSION)
	$(THUNDER_PERSISTENT_PERMISSION)
endef
$(eval $(cmake-package))
