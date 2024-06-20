EXTERNAL_ML_OSS_REFERENCE=$(shell pushd $(BR2_EXTERNAL_ML_OSS_PATH) &> /dev/null && $(GIT) rev-parse --short HEAD; popd &> /dev/null)
EXTERNAL_ML_OSS_DIRTY=$(shell pushd $(BR2_EXTERNAL_ML_OSS_PATH) &> /dev/null && $(GIT) diff --shortstat 2>/dev/null | wc -l ; popd &> /dev/null)

BUILDROOT_REFERENCE=$(shell $(GIT) rev-parse --short HEAD)
BUILDROOT_DIRTY=$(shell $(GIT) diff --shortstat 2>/dev/null | wc -l)

include $(sort $(wildcard $(BR2_EXTERNAL_ML_OSS_PATH)/package/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_ML_OSS_PATH)/adaptation/*/*.mk))
