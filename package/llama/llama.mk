################################################################################
#
# llama
#
################################################################################
LLAMA_VERSION = 8d59d911711b8f1ba9ec57c4b192ccd2628af033
LLAMA_SITE = $(call github,ggerganov,llama.cpp,$(LLAMA_VERSION))
LLAMA_INSTALL_STAGING = YES
# LLAMA_DEPENDENCIES = 

ifeq ($(BR2_arm)$(BR2_aarch64),y)
LLAMA_CONF_OPTS += -DCMAKE_C_FLAGS="-mfp16-format=ieee" \
                   -DCMAKE_CXX_FLAGS="-mfp16-format=ieee"
endif



$(eval $(cmake-package))
