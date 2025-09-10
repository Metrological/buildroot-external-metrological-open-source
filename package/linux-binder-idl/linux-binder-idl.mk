################################################################################
#
# linux-binder-idl
#
################################################################################

LINUX_BINDER_IDL_VERSION = main
LINUX_BINDER_IDL_SITE = https://github.com/rdkcentral/linux_binder_idl.git
LINUX_BINDER_IDL_SITE_METHOD = git

LINUX_BINDER_IDL_BUILDDIR = $(@D)/out
LINUX_BINDER_IDL_EXAMPLES_DIR = $(@D)/example
LINUX_BINDER_IDL_EXAMPLES_BUILD_DIR = $(LINUX_BINDER_IDL_EXAMPLES_DIR)/out

define LINUX_BINDER_IDL_SETUP_ANDROID_REPOS
	cd $(@D) && . ./setup-env.sh && clone_android_binder_repo
endef

LINUX_BINDER_IDL_POST_EXTRACT_HOOKS += LINUX_BINDER_IDL_SETUP_ANDROID_REPOS

LINUX_BINDER_IDL_CONF_OPTS += -DTARGET_LIB64_VERSION=ON


CMAKE = $(HOST_DIR)/bin/cmake

define LINUX_BINDER_IDL_CONFIGURE_CMDS
	mkdir -p $(LINUX_BINDER_IDL_BUILDDIR)
	@echo "STAGING DIR - $(STAGING_DIR)"
	cd $(LINUX_BINDER_IDL_BUILDDIR) && \
		$(CMAKE) $(@D) \
			-DCMAKE_TOOLCHAIN_FILE=$(HOST_DIR)/share/buildroot/toolchainfile.cmake \
			-DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/usr \
			-DCMAKE_INSTALL_INCDIR=$(STAGING_DIR)/usr/include \
			-DANDROID_BUILD_TOOLS_DIR=$(HOST_DIR)/bin \
			$(LINUX_BINDER_IDL_CONF_OPTS)
endef

define LINUX_BINDER_IDL_BUILD_CMDS
	$(MAKE) -C $(LINUX_BINDER_IDL_BUILDDIR)
	@echo ">>> Installing linux-binder-idl core to staging"
        $(MAKE) -C $(LINUX_BINDER_IDL_BUILDDIR) install
endef

define LINUX_BINDER_IDL_INSTALL_TARGET_CMDS
	@echo ">>> Installing linux-binder-idl core libs to target"

	# Install libraries
	for lib in libbase.so libbinder.so libcutils.so libcutils_sockets.so \
	           libfwmanager.so liblog.so libutils.so; do \
		if [ -f $(STAGING_DIR)/usr/lib/$$lib ]; then \
			$(INSTALL) -D -m 0755 $(STAGING_DIR)/usr/lib/$$lib $(TARGET_DIR)/usr/lib/$$lib; \
		fi; \
	done

	@echo ">>> Installing linux-binder-idl bins to target"
	# Install executables
	for bin in FWManagerClient FWManagerService RTTPerformanceClient \
	           RTTPerformanceService servicemanager; do \
		if [ -f $(STAGING_DIR)/usr/bin/$$bin ]; then \
			$(INSTALL) -D -m 0755 $(STAGING_DIR)/usr/bin/$$bin $(TARGET_DIR)/usr/bin/$$bin; \
		fi; \
	done
	@echo ">>> Install target done"
endef

define LINUX_BINDER_IDL_BUILD_EXAMPLES
        mkdir -p $(LINUX_BINDER_IDL_EXAMPLES_BUILD_DIR)
        cd $(LINUX_BINDER_IDL_EXAMPLES_BUILD_DIR) && \
                $(CMAKE) $(LINUX_BINDER_IDL_EXAMPLES_DIR) \
                        -DCMAKE_TOOLCHAIN_FILE=$(HOST_DIR)/share/buildroot/toolchainfile.cmake \
                        -DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/usr \
			-DCMAKE_INSTALL_INCDIR=$(STAGING_DIR)/usr/include \
                        -DANDROID_BUILD_TOOLS_DIR=$(HOST_DIR)/bin \
                        $(LINUX_BINDER_IDL_CONF_OPTS)

        $(MAKE) -C $(LINUX_BINDER_IDL_EXAMPLES_BUILD_DIR)
	$(MAKE) -C $(LINUX_BINDER_IDL_EXAMPLES_BUILD_DIR) install
endef

LINUX_BINDER_IDL_PRE_INSTALL_TARGET_HOOKS += LINUX_BINDER_IDL_BUILD_EXAMPLES 

define LINUX_BINDER_IDL_INSTALL_INIT_SCRIPT
    $(INSTALL) -D -m 0755 $(BR2_EXTERNAL_ML_OSS_PATH)/board/raspberry/S10Binder $(TARGET_DIR)/etc/init.d/S10Binder
endef
LINUX_BINDER_IDL_POST_INSTALL_TARGET_HOOKS += LINUX_BINDER_IDL_INSTALL_INIT_SCRIPT

$(eval $(generic-package))
