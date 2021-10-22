################################################################################
#
# thunder-provisioning
#
################################################################################
THUNDER_PROVISIONING_VERSION = f81e2c36e546bf864647b6d11780a5f3d27e3a8f
THUNDER_PROVISIONING_SITE_METHOD = git
THUNDER_PROVISIONING_SITE = git@github.com:WebPlatformForEmbedded/WPEPluginProvisioning.git
THUNDER_PROVISIONING_INSTALL_STAGING = YES
THUNDER_PROVISIONING_DEPENDENCIES = thunder thunder-clientlibraries

THUNDER_PROVISIONING_CONF_OPTS += -DBUILD_REFERENCE=${THUNDER_PROVISIONING_VERSION}

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
THUNDER_PROVISIONING_CONF_OPTS += -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

ifeq ($(BR2_PACKAGE_THUNDER_PROVISIONING),y)
ifeq ($(BR2_PACKAGE_THUNDER_PROVISIONING_CLOUD),y)
THUNDER_PROVISIONING_CONF_OPTS += -DENABLE_METROLOGICAL_CLOUD=ON

THUNDER_PROVISIONING_CONF_OPTS += -DTHUNDER_PROVISIONING_URI=${BR2_PACKAGE_THUNDER_PROVISIONING_URI}
THUNDER_PROVISIONING_CONF_OPTS += -DPLUGIN_PROVISIONING_OPERATOR=${BR2_PACKAGE_THUNDER_PROVISIONING_OPERATOR}

ifeq ($(shell expr $(BR2_PACKAGE_THUNDER_PROVISIONING_PROVISIONING_CACHE_PERIODE) \> 0),1)
THUNDER_PROVISIONING_CONF_OPTS += -DPLUGIN_PROVISIONING_CACHE=$(call qstrip,$(BR2_PACKAGE_THUNDER_PROVISIONING_PROVISIONING_CACHE_PERIODE)) 
endif
endif # BR2_PACKAGE_THUNDER_PROVISIONING_CLOUD

ifeq ($(BR2_PACKAGE_THUNDER_PROVISIONING_FILES),y)
THUNDER_PROVISIONING_CONF_OPTS += -DENABLE_METROLOGICAL_FILES=ON

ifneq ($(BR2_PACKAGE_THUNDER_PROVISIONING_VAULT_LOCATION),"")
THUNDER_PROVISIONING_CONF_OPTS += -DPLUGIN_PROVISIONING_VAULT_LOCATION="$(call qstrip,$(BR2_PACKAGE_THUNDER_PROVISIONING_VAULT_LOCATION))"
endif
endif # BR2_PACKAGE_THUNDER_PROVISIONING_FILES

ifeq ($(BR2_PACKAGE_THUNDER_PROVISIONING_WIDEVINE),y)
THUNDER_PROVISIONING_CONF_OPTS += -DENABLE_WIDEVINE_PROVIONING=ON

ifeq ($(BR2_PACKAGE_THUNDER_PROVISIONING_WIDEVINE_LOG_LEVEL_0),y)
  THUNDER_PROVISIONING_CONF_OPTS += -DPLUGIN_PROVISIONING_WV_LOGLEVEL=0
else ifeq ($( BR2_PACKAGE_THUNDER_PROVISIONING_WIDEVINE_LOG_LEVEL_1),y)
  THUNDER_PROVISIONING_CONF_OPTS += -DPLUGIN_PROVISIONING_WV_LOGLEVEL=1
else ifeq ($(BR2_PACKAGE_THUNDER_PROVISIONING_WIDEVINE_LOG_LEVEL_2),y)
  THUNDER_PROVISIONING_CONF_OPTS += -DPLUGIN_PROVISIONING_WV_LOGLEVEL=2
else ifeq ($(BR2_PACKAGE_THUNDER_PROVISIONING_WIDEVINE_LOG_LEVEL_3),y)
  THUNDER_PROVISIONING_CONF_OPTS += -DPLUGIN_PROVISIONING_WV_LOGLEVEL=3
else ifeq ($(BR2_PACKAGE_THUNDER_PROVISIONING_WIDEVINE_LOG_LEVEL_4),y)
  THUNDER_PROVISIONING_CONF_OPTS += -DPLUGIN_PROVISIONING_WV_LOGLEVEL=4
endif
endif # BR2_PACKAGE_THUNDER_PROVISIONING_WIDEVINE
endif # BR2_PACKAGE_THUNDER_PROVISIONING

ifeq ($(BR2_PACKAGE_THUNDER_PROVISIONING_BLOBWRITER),y)
THUNDER_PROVISIONING_CONF_OPTS += -DPLUGIN_BLOBWRITER=ON

ifneq ($(BR2_PACKAGE_THUNDER_PROVISIONING_BLOBWRITER_BLOBS),)
THUNDER_PROVISIONING_CONF_OPTS += -DPLUGIN_BLOBWRITER_BLOBS="$(call qstrip,$(BR2_PACKAGE_THUNDER_PROVISIONING_BLOBWRITER_BLOBS))"
endif
endif # BR2_PACKAGE_THUNDER_PROVISIONING_BLOBWRITER

$(eval $(cmake-package))
