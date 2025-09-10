################################################################################
#
# binder
#
################################################################################

BINDER_SITE = git@github.com:WebPlatformForEmbedded/Binder.git
BINDER_SITE_METHOD = git
BINDER_VERSION = origin/master
BINDER_VERSION_IS_BRANCH = YES


BINDER_LICENSE = Apache-2.0
BINDER_LICENSE_FILES = LICENSE

BINDER_INSTALL_STAGING = YES
BINDER_INSTALL_TARGET = YES

# If you need extra CMake flags, add them here:
BINDER_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX=/usr

$(eval $(cmake-package))
