################################################################################
#
# Thunder UI
#
################################################################################
THUNDER_UI_VERSION = R5.2.0
THUNDER_UI_SITE = $(call github,rdkcentral,ThunderUI,$(THUNDER_UI_VERSION))
THUNDER_UI_DEPENDENCIES = thunder

THUNDER_UI_INSTALL_STAGING = NO
THUNDER_UI_INSTALL_TARGET = YES

THUNDER_UI_CONFIGURE_CMDS = true
THUNDER_UI_BUILD_CMDS = true

define THUNDER_UI_INSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/usr/share/Thunder/Controller/UI
	mkdir -p $(TARGET_DIR)/usr/share/Thunder/Controller/UI
	cp -r $(@D)/dist/* $(TARGET_DIR)/usr/share/Thunder/Controller/UI
endef

$(eval $(generic-package))
