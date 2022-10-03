################################################################################
#
# ssl-key
#
################################################################################
SSL_KEY_VERSION = 1.0
SSL_KEY_SOURCE = dummy.tar
SSL_KEY_SITE = file://${SSL_KEY_PKGDIR}${SSL_KEY_SOURCE}
SSL_KEY_LICENSE = NONE

SSL_KEY_INSTALL_STAGING = NO
SSL_KEY_INSTALL_TARGET = YES

SSL_KEY_PRIVATE_KEY = $(call qstrip,${SSL_KEY_BUILDDIR}buildroot-debug-access)
SSL_KEY_PUBLIC_KEY = $(call qstrip,$(BR2_PACKAGE_SSL_KEY_CUSTOM_PUBLIC_KEY))

define SSL_KEY_GENERATE_KEY_PAIR
@if [ ! -f ${SSL_KEY_PRIVATE_KEY} ]; then \
  @ssh-keygen -t ed25519 -C "buildroot@debug.access" -N "" -f ${SSL_KEY_PRIVATE_KEY}; \
fi
endef

ifeq ($(SSL_KEY_PUBLIC_KEY),)
    SSL_KEY_INSTALL_IMAGES = YES

    SSL_KEY_PUBLIC_KEY = ${SSL_KEY_PRIVATE_KEY}.pub

    define SSL_KEY_CONFIGURE_CMDS
        @$(call MESSAGE,"Use Generated SSL ED25519 key")
        @$(call SSL_KEY_GENERATE_KEY_PAIR)
    endef

    define SSL_KEY_INSTALL_IMAGES_CMDS
        @mkdir -p ${BINARIES_DIR}/ssh
        @cp -v ${SSL_KEY_PRIVATE_KEY}* ${BINARIES_DIR}/ssh
    endef
else 
    SSL_KEY_INSTALL_IMAGES = NO
    
	define SSL_KEY_CONFIGURE_CMDS
        @$(call MESSAGE,"Use Custom SSL key ${SSL_KEY_PUBLIC_KEY}")
    endef

endif

define SSL_KEY_BUILD_CMDS
endef

define SSL_KEY_INSTALL_STAGING_CMDS
endef

define SSL_KEY_INSTALL_TARGET_CMDS
    @if [ -L ${TARGET_DIR}/etc/dropbear ]; then \
	    echo "It's a link, remove it"; \
		rm ${TARGET_DIR}/etc/dropbear; \
    fi

	@mkdir -p ${TARGET_DIR}/etc/dropbear
    @touch ${TARGET_DIR}/etc/dropbear/authorized_keys

	@cat ${SSL_KEY_PUBLIC_KEY} >> ${TARGET_DIR}/etc/dropbear/authorized_keys
	@sort -u ${TARGET_DIR}/etc/dropbear/authorized_keys > ${TARGET_DIR}/etc/dropbear/authorized_keys.tmp
	@mv -v ${TARGET_DIR}/etc/dropbear/authorized_keys.tmp ${TARGET_DIR}/etc/dropbear/authorized_keys

    @if [ ! -L ${TARGET_DIR}/root/.ssh/authorized_keys ]; then \
	    echo "Create Link for ${TARGET_DIR}/root/.ssh/authorized_keys"; \
	    mkdir -p ${TARGET_DIR}/root/.ssh; \
	    ln -vsf /etc/dropbear/authorized_keys ${TARGET_DIR}/root/.ssh/authorized_keys; \
	fi
endef

$(eval $(generic-package))
