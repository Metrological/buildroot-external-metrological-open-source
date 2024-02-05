################################################################################
#
# gyp
#
################################################################################

GYP_VERSION = 2d207fd1699c88dcf6dfdd819d940c0dd227ffe7
GYP_SITE_METHOD = git
GYP_SITE = https://chromium.googlesource.com/external/gyp
GYP_INSTALL_STAGING = NO
GYP_SETUP_TYPE = setuptools
GYP_DEPENDENCIES = host-gyp 
HOST_GYP_DEPENDENCIES = host-python3 host-python-setuptools

define HOST_GYP_CONFIGURE_CMDS
	(cd $(@D); rm -rf build)
endef

define HOST_GYP_BUILD_CMDS
	$(HOST_MAKE_ENV) PYTHON=$(HOST_DIR)/usr/bin/python3;
	cd $(@D);$(PYTHON) ./setup.py build;
endef

define HOST_GYP_INSTALL_CMDS
        $(HOST_MAKE_ENV) PYTHON=$(HOST_DIR)/usr/bin/python3;
        cd $(@D);$(PYTHON) ./setup.py install;
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
