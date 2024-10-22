################################################################################
#
# bun
#
################################################################################
BUN_VERSION = main
BUN_SITE = $(call github,oven-sh,bun,$(BUN_VERSION))
BUN_LICENSE = MIT
BUN_LICENSE_FILES = COPYING
BUN_INSTALL_STAGING = YES
BUN_DEPENDENCIES = zlib host-rust-bin brotli zstd libarchive libdeflate c-ares

#  BoringSSL
#  LolHtml
#  Lshpack
#  Mimalloc
#  TinyCC

BUN_CONF_OPTS += -DENABLE_LLVM=OFF -DLINUX=ON

$(eval $(cmake-package))
