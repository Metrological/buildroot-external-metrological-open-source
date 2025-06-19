# Version Comparison
version_le = $(shell if printf '%s\n' "$(1)" "$(2)" | sort -VC ; then echo 1; fi)
version_ge = $(shell if printf '%s\n' "$(1)" "$(2)" | sort -VCr ; then echo 1; fi)
version_lt = $(shell if [ "$(1)" != "$(2)" ] && printf "%s\n" "$(1)" "$(2)" | sort -VC ; then echo 1; fi)
version_gt = $(shell if [ "$(1)" != "$(2)" ] && printf "%s\n" "$(1)" "$(2)" | sort -VCr ; then echo 1; fi)

include $(sort $(wildcard $(BR2_EXTERNAL_ML_OSS_PATH)/adaptation/*/*.mk))