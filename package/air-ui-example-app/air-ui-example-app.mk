################################################################################
#
# air-ui-example-app
#
################################################################################
BLITS_EXAMPLE_APP_VERSION = 91ea8c9be982fadef92f5abe291a8323b2deb27c
BLITS_EXAMPLE_APP_SITE = $(call github,erikhaandrikman,blits-example-app,$(BLITS_EXAMPLE_APP_VERSION))
BLITS_EXAMPLE_APP_DEPENDENCIES = host-nodejs

BLITS_EXAMPLE_APP_INSTALL_STAGING = NO
BLITS_EXAMPLE_APP_INSTALL_TARGET = YES

NODEJS_EXECUTABLE = ${HOST_DIR}/usr/bin/npm
TARGET_WWW = $(TARGET_DIR)/var/www

define BLITS_EXAMPLE_APP_CONFIGURE_CMDS
    ${NODEJS_EXECUTABLE} install --prefix $(@D)
endef

define BLITS_EXAMPLE_APP_BUILD_CMDS
    ${NODEJS_EXECUTABLE} run build --prefix $(@D)
endef

define BLITS_EXAMPLE_APP_INSTALL_TARGET_CMDS
    $(INSTALL) -d $(TARGET_WWW)/blits
    rsync -av  $(@D)/dist/* $(TARGET_WWW)/blits
endef

$(eval $(generic-package))
