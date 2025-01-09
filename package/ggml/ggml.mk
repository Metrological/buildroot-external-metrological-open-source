################################################################################
#
# ggml
#
################################################################################
GGML_VERSION = c8bd0fee71dc8328d93be301bbee06bc10d30429
GGML_SITE = $(call github,ggerganov,ggml,$(GGML_VERSION))
GGML_INSTALL_STAGING = YES
# GGML_DEPENDENCIES = 

GGML_CONF_OPTS  = -DGGML_BUILD_TESTS=OFF

ifeq ($(BR2_arm)$(BR2_aarch64),y)
GGML_CONF_OPTS += -DCMAKE_C_FLAGS="-mfp16-format=ieee" \
                  -DCMAKE_CXX_FLAGS="-mfp16-format=ieee"
endif

$(eval $(cmake-package))
