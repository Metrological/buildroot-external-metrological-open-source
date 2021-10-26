################################################################################
#
# thunder-rdkservices
#
################################################################################
ifeq ($(THUNDER_RDKSERVICES_SITE_RDKCENTRAL),y)
THUNDER_RDKSERVICES_VERSION = 395444d287f49f0dc0ff329b12f4554f5c349842
THUNDER_RDKSERVICES_SITE = git@github.com:rdkcentral/rdkservices.git
endif

ifeq ($(THUNDER_RDKSERVICES_SITE_WEBPLATFORMFOREMBEDDED),y)
THUNDER_RDKSERVICES_VERSION = c195b466b976ce8d722080549882bbeea59255ed
THUNDER_RDKSERVICES_SITE = git@github.com:WebPlatformForEmbedded/ThunderNanoServicesRDK.git
endif

THUNDER_RDKSERVICES_SITE_METHOD = git
THUNDER_RDKSERVICES_INSTALL_STAGING = YES
THUNDER_RDKSERVICES_DEPENDENCIES = thunder-clientlibraries

THUNDER_RDKSERVICES_OPKG_NAME = "thunder-rdkservices"
THUNDER_RDKSERVICES_OPKG_VERSION = "1.0.0"
THUNDER_RDKSERVICES_OPKG_ARCHITECTURE = "${BR2_ARCH}"
THUNDER_RDKSERVICES_OPKG_MAINTAINER = "Metrological"
THUNDER_RDKSERVICES_OPKG_DESCRIPTION = "WPEFramework rdkservices"

THUNDER_RDKSERVICES_CONF_OPTS += -DBUILD_REFERENCE=${THUNDER_RDKSERVICES_VERSION}


ifeq ($(THUNDER_RDKSERVICES_SITE_RDKCENTRAL),y)
# Fix some unwanted configuration polution... :-(
THUNDER_RDKSERVICES_CONF_OPTS += -DCOMCAST_CONFIG=OFF

# Fix old dusty code to the new standard 
THUNDER_RDKSERVICES_PKGDIR = "$(BR2_EXTERNAL_ML_OSS_PATH)/package/thunder/thunder-rdkservices"

define THUNDER_RDKSERVICES_APPLY_RDKCENTRAL_FIXES
 $(APPLY_PATCHES) $(@D) $(THUNDER_RDKSERVICES_PKGDIR) 9999-proxy_cast-Remove-proxy_cast-in-favour-of-the-constr.patch.conditional
endef

THUNDER_RDKSERVICES_POST_PATCH_HOOKS += THUNDER_RDKSERVICES_APPLY_RDKCENTRAL_FIXES
endif

ifeq ($(BR2_PACKAGE_THUNDER_DEVICEINFO),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_DEVICEINFO=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_MONITOR),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR=ON
ifneq ($(BR2_PACKAGE_THUNDER_MONITOR_WEBKITBROWSER),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_WEBKITBROWSER_WEBKIT=ON
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_WEBKITBROWSER_MEMORYLIMIT=${BR2_PACKAGE_THUNDER_MONITOR_WEBKITBROWSER}
endif
ifneq ($(BR2_PACKAGE_THUNDER_MONITOR_WEBKITBROWSER_APPS),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_WEBKITBROWSER_APPS=ON
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_WEBKITBROWSER_APPS_MEMORYLIMIT=${BR2_PACKAGE_THUNDER_MONITOR_WEBKITBROWSER_APPS}
endif
ifneq ($(BR2_PACKAGE_THUNDER_MONITOR_WEBKITBROWSER_UX),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_WEBKITBROWSER_UX=ON
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_WEBKITBROWSER_UX_MEMORYLIMIT=${BR2_PACKAGE_THUNDER_MONITOR_WEBKITBROWSER_UX}
endif
ifneq ($(BR2_PACKAGE_THUNDER_MONITOR_WEBKITBROWSER_YOUTUBE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_WEBKITBROWSER_YOUTUBE=ON
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_WEBKITBROWSER_YOUTUBE_MEMORYLIMIT=${BR2_PACKAGE_THUNDER_MONITOR_WEBKITBROWSER_YOUTUBE}
endif
ifneq ($(BR2_PACKAGE_THUNDER_MONITOR_AMAZON),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_AMAZON=ON
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_AMAZON_MEMORYLIMIT=${BR2_PACKAGE_THUNDER_MONITOR_AMAZON}
endif
ifneq ($(BR2_PACKAGE_THUNDER_MONITOR_COBALT),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_COBALT=ON
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_COBALT_MEMORYLIMIT=${BR2_PACKAGE_THUNDER_MONITOR_COBALT}
endif
ifneq ($(BR2_PACKAGE_THUNDER_MONITOR_NETFLIX),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_NETFLIX=ON
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_NETFLIX_MEMORYLIMIT=${BR2_PACKAGE_THUNDER_MONITOR_NETFLIX}
endif
ifneq ($(BR2_PACKAGE_THUNDER_MONITOR_OPENCDMI),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MONITOR_OPENCDMI=ON
endif
endif

ifeq ($(BR2_PACKAGE_THUNDER_TRACECONTROL),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_TRACECONTROL=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_WARNINGREPORTINGCONTROL),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WARNINGREPORTINGCONTROL=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_LOCATIONSYNC),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_LOCATIONSYNC=ON
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_LOCATIONSYNC_URI=${BR2_PACKAGE_THUNDER_LOCATIONSYNC_URI}
endif

ifeq ($(BR2_PACKAGE_THUNDER_CDMI),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI=ON
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_AUTOSTART=true
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_OUTOFPROCESS=true
ifneq ($(BR2_PACKAGE_THUNDER_CDMI_WIDEVINE_KEYBOX),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_WIDEVINE_KEYBOX="$(call qstrip,$(BR2_PACKAGE_THUNDER_CDMI_WIDEVINE_KEYBOX))"
endif
ifneq ($(BR2_PACKAGE_THUNDER_CDMI_WIDEVINE_DEVICE_CERTIFICATE),"")
THUNDER_RDKSERVICES_CONF_OPTS += \
    -DPLUGIN_OPENCDMI_WIDEVINE_DEVICE_CERTIFICATE="$(call qstrip,$(BR2_PACKAGE_THUNDER_CDMI_WIDEVINE_DEVICE_CERTIFICATE))"
endif

ifneq ($(BR2_PACKAGE_THUNDER_CDMI_WIDEVINE_STORAGE_LOCATION),"")
THUNDER_RDKSERVICES_CONF_OPTS += \
    -DPLUGIN_OPENCDMI_WIDEVINE_STORAGE_LOCATION="$(call qstrip,$(BR2_PACKAGE_THUNDER_CDMI_WIDEVINE_STORAGE_LOCATION))"
endif
ifneq ($(BR2_PACKAGE_THUNDER_CDMI_USER),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_USER=$(BR2_PACKAGE_THUNDER_CDMI_USER)
endif
ifneq ($(BR2_PACKAGE_THUNDER_CDMI_GROUP),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_GROUP=$(BR2_PACKAGE_THUNDER_CDMI_GROUP)
endif
ifeq ($(BR2_PACKAGE_THUNDER_CDMI_CLEARKEY),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_CLEARKEY=ON
THUNDER_RDKSERVICES_DEPENDENCIES += thunder-cdmi-clearkey
endif
ifeq ($(BR2_PACKAGE_THUNDER_CDMI_PLAYREADY),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_PLAYREADY=ON
THUNDER_RDKSERVICES_DEPENDENCIES += thunder-cdmi-playready
ifneq ($(BR2_PACKAGE_THUNDER_CDMI_PLAYREADY_CERTIFICATE_LABEL),"")
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_PLAYREADY_CERTIFICATE_LABEL="$(call qstrip,$(BR2_PACKAGE_THUNDER_CDMI_PLAYREADY_CERTIFICATE_LABEL))"
endif
endif
ifeq ($(BR2_PACKAGE_THUNDER_CDMI_PLAYREADY_NEXUS),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_PLAYREADY_NEXUS=ON
THUNDER_RDKSERVICES_DEPENDENCIES += thunder-cdmi-playready-nexus
endif
ifeq ($(BR2_PACKAGE_THUNDER_CDMI_PLAYREADY_NEXUS_SVP),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_PLAYREADY_NEXUS=ON
THUNDER_RDKSERVICES_DEPENDENCIES += thunder-cdmi-playready-nexus-svp
ifneq ($(BR2_PACKAGE_THUNDER_CDMI_PLAYREADY_SECURE_STOP_METERING_CERTIFICATE),"")
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_PLAYREADY_METERING_CERTIFICATE="$(call qstrip,$(BR2_PACKAGE_THUNDER_CDMI_PLAYREADY_SECURE_STOP_METERING_CERTIFICATE))"
endif
endif
ifeq ($(BR2_PACKAGE_THUNDER_CDMI_PLAYREADY_VGDRM),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_PLAYREADY_VGDRM=ON
THUNDER_RDKSERVICES_DEPENDENCIES += thunder-cdmi-playready-vgdrm
endif
ifeq ($(BR2_PACKAGE_THUNDER_CDMI_WIDEVINE),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_WIDEVINE=ON
THUNDER_RDKSERVICES_DEPENDENCIES += thunder-cdmi-widevine
endif
ifeq ($(BR2_PACKAGE_THUNDER_CDMI_WIDEVINE_NEXUS_SVP),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DOPENCDMI_WIDEVINE_NEXUS_SVP=ON
THUNDER_RDKSERVICES_DEPENDENCIES += thunder-cdmi-widevine-nexus-svp
endif
ifeq ($(BR2_PACKAGE_THUNDER_CDMI_NAGRA),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_NAGRA=ON
THUNDER_RDKSERVICES_DEPENDENCIES += thunder-cdmi-nagra
endif
ifeq ($(BR2_PACKAGE_THUNDER_CDMI_NCAS),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_OPENCDMI_NCAS=ON
THUNDER_RDKSERVICES_DEPENDENCIES += thunder-cdmi-ncas
endif
endif

ifeq ($(BR2_PACKAGE_THUNDER_MESSENGER),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_MESSENGER=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_SECURITYAGENT),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_SECURITYAGENT=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_PACKAGER),y)
THUNDER_RDKSERVICES_DEPENDENCIES += opkg
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_PACKAGER=ON
endif

ifeq  ($(BR2_PACKAGE_THUNDER_DEVICEIDENTIFICATION),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_DEVICEIDENTIFICATION=ON
THUNDER_RDKSERVICES_CONF_OPTS += -DDEVICEIDENTIFICATION_IMPLEMENTATION_REPOSITORY=git@github.com:WebPlatformForEmbedded/DeviceIdentification-brcm.git
endif

ifeq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER),y)
THUNDER_RDKSERVICES_DEPENDENCIES += wpewebkit
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER=ON
ifneq ($(BR2_PACKAGE_WPEWEBKIT_ALTERNATIVE_EXEC_PATH),"")
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_ALTERNATIVE_EXEC_PATH="$(call qstrip,$(BR2_PACKAGE_WPEWEBKIT_ALTERNATIVE_EXEC_PATH))"
endif
ifeq ($(BR2_PACKAGE_THUNDER_AMAZON_TAB),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_HYBRID=ON
endif
ifeq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_AUTOSTART),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_AUTOSTART=true
else
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_AUTOSTART=false
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_STARTURL),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_STARTURL=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_STARTURL)
else
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_STARTURL="file:///www/index.html"
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_USERAGENT),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_USERAGENT=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_USERAGENT)
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_MEMORYPROFILE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_MEMORYPROFILE=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_MEMORYPROFILE)
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_MEMORYPRESSURE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_MEMORYPRESSURE=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_MEMORYPRESSURE)
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_MEDIA_CONTENT_TYPES_REQUIRING_HARDWARE_SUPPORT),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_MEDIA_CONTENT_TYPES_REQUIRING_HARDWARE_SUPPORT=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_MEDIA_CONTENT_TYPES_REQUIRING_HARDWARE_SUPPORT)
endif
ifeq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_MEDIADISKCACHE),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_MEDIADISKCACHE=true
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_DISKCACHE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_DISKCACHE=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_DISKCACHE)
endif
ifeq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_XHRCACHE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_XHRCACHE=false
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_CLIENTIDENTIFIER),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_CLIENTIDENTIFIER=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_CLIENTIDENTIFIER)
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_LOCALSTORAGE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_LOCALSTORAGE=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_LOCALSTORAGE)
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_COOKIESTORAGE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_COOKIESTORAGE=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_COOKIESTORAGE)
endif
ifeq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_WINDOWCLOSE),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_WINDOWCLOSE=true
else
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_WINDOWCLOSE=false
endif
ifeq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_DISABLE_WEBGL),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_WEBGL=false
endif
ifeq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_TRANSPARENT),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_TRANSPARENT=true
else
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_TRANSPARENT=false
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_THREADEDPAINTING),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_THREADEDPAINTING=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_THREADEDPAINTING)
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_USER),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_USER=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_USER)
endif
ifneq ($(BR2_PACKAGE_THUNDER_WEBKITBROWSER_GROUP),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_GROUP=$(BR2_PACKAGE_THUNDER_WEBKITBROWSER_GROUP)
endif
ifeq ($(BR2_PACKAGE_THUNDER_BROWSER_RESOLUTION_720P),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_RESOLUTION=720p
else ifeq ($(BR2_PACKAGE_THUNDER_BROWSER_RESOLUTION_1080P),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_RESOLUTION=1080p
else ifeq ($(BR2_PACKAGE_THUNDER_BROWSER_RESOLUTION_2160P),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_RESOLUTION=2160p
endif
ifeq ($(BR2_PACKAGE_THUNDER_YOUTUBE),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_YOUTUBE=ON
ifneq ($(BR2_PACKAGE_THUNDER_YOUTUBE_USERAGENT),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_YOUTUBE_USERAGENT=$(BR2_PACKAGE_THUNDER_YOUTUBE_USERAGENT)
endif
endif
ifeq ($(BR2_PACKAGE_THUNDER_AMAZON_TAB),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_AMAZON=ON
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_STARTURL),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_STARTURL=$(BR2_PACKAGE_THUNDER_AMAZON_STARTURL)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_CA_DIRECTORY_PATH),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_CADIRECTORYPATH=$(BR2_PACKAGE_THUNDER_AMAZON_CA_DIRECTORY_PATH)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_CA_BUNDLE_FILENAME),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_CABUNDLEFILENAME=$(BR2_PACKAGE_THUNDER_AMAZON_CA_BUNDLE_FILENAME)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_MANUFACTURER),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_MANUFACTURER=$(BR2_PACKAGE_THUNDER_AMAZON_MANUFACTURER)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_MODELNAME),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_MODELNAME=$(BR2_PACKAGE_THUNDER_AMAZON_MODELNAME)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_DEVICELANGUAGE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_DEVICELANGUAGE=$(BR2_PACKAGE_THUNDER_AMAZON_DEVICELANGUAGE)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_DEVICETYPEID),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_DEVICETYPEID=$(BR2_PACKAGE_THUNDER_AMAZON_DEVICETYPEID)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_FIRMWARE_VERSION),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_FIRMWAREVERSION=$(BR2_PACKAGE_THUNDER_AMAZON_FIRMWARE_VERSION)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_CHIPSET_NAME),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_CHIPSETNAME=$(BR2_PACKAGE_THUNDER_AMAZON_CHIPSET_NAME)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_ETHERNET_DEVICE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_ETHERNETDEVICE=$(BR2_PACKAGE_THUNDER_AMAZON_ETHERNET_DEVICE)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_FRAGMENT_CACHE_SIZE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_FRAGMENTCACHESIZE=$(BR2_PACKAGE_THUNDER_AMAZON_FRAGMENT_CACHE_SIZE)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_USERAGENT),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_USERAGENT=$(BR2_PACKAGE_THUNDER_AMAZON_USERAGENT)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_USER),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_USER=$(BR2_PACKAGE_THUNDER_AMAZON_USER)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_GROUP),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_GROUP=$(BR2_PACKAGE_THUNDER_AMAZON_GROUP)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_MEMORYPROFILE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_MEMORYPROFILE=$(BR2_PACKAGE_THUNDER_AMAZON_MEMORYPROFILE)
endif
ifneq ($(BR2_PACKAGE_THUNDER_AMAZON_MEMORYPRESSURE),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_MEMORYPRESSURE=$(BR2_PACKAGE_THUNDER_AMAZON_MEMORYPRESSURE)
endif
ifeq ($(BR2_PACKAGE_THUNDER_AMAZON_TRANSPARENT),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_TRANSPARENT=true
else
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_TRANSPARENT=false
endif
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_AMAZON_HAWAII=ON
endif
ifeq ($(BR2_PACKAGE_THUNDER_APPS),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_APPS=ON
ifeq ($(BR2_PACKAGE_THUNDER_APPS_AUTOSTART),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_APPS_AUTOSTART=true
endif
ifneq ($(BR2_PACKAGE_THUNDER_APPS_USERAGENT),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_APPS_USERAGENT=$(BR2_PACKAGE_THUNDER_APPS_USERAGENT)
endif
endif
ifeq ($(BR2_PACKAGE_THUNDER_RESIDENTAPP),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_RESIDENT_APP=ON
ifeq ($(BR2_PACKAGE_THUNDER_RESIDENTAPP_AUTOSTART),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_RESIDENT_APP_AUTOSTART=true
endif
ifneq ($(BR2_PACKAGE_THUNDER_RESIDENTAPP_USERAGENT),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_RESIDENT_APP_USERAGENT=$(BR2_PACKAGE_THUNDER_RESIDENTAPP_USERAGENT)
endif
endif
ifeq ($(BR2_PACKAGE_THUNDER_UX),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_WEBKITBROWSER_UX=ON
ifeq ($(BR2_PACKAGE_THUNDER_UX_AUTOSTART),y)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_UX_AUTOSTART=true
endif
ifneq ($(BR2_PACKAGE_THUNDER_UX_USERAGENT),)
THUNDER_RDKSERVICES_CONF_OPTS += -DPLUGIN_UX_USERAGENT=$(BR2_PACKAGE_THUNDER_UX_USERAGENT)
endif
endif
endif

$(eval $(cmake-package))
