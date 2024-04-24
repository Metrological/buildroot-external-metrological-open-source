################################################################################
#
# python3-setuptools
#
################################################################################

# Please keep in sync with
# package/python-setuptools/python-setuptools.mk
PYTHON3_SETUPTOOLS_VERSION = 68.2.2
PYTHON3_SETUPTOOLS_SOURCE = setuptools-$(PYTHON3_SETUPTOOLS_VERSION).tar.gz
PYTHON3_SETUPTOOLS_SITE = https://files.pythonhosted.org/packages/ef/cc/93f7213b2ab5ed383f98ce8020e632ef256b406b8569606c3f160ed8e1c9
PYTHON3_SETUPTOOLS_LICENSE = MIT
PYTHON3_SETUPTOOLS_LICENSE_FILES = LICENSE
PYTHON3_SETUPTOOLS_SETUP_TYPE = setuptools
PYTHON3_SETUPTOOLS_SETUP_TYPE = pep517
#PYTHON3_SETUPTOOLS_DEPENDENCIES = host-python-wheel
#HOST_PYTHON_SETUPTOOLS_DEPENDENCIES = host-python-wheel
HOST_PYTHON3_SETUPTOOLS_DL_SUBDIR = python-setuptools
HOST_PYTHON3_SETUPTOOLS_NEEDS_HOST_PYTHON = python3

define HOST_PYTHON3_SETUPTOOLS_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(HOST_PYTHON3_SETUPTOOLS_DL_DIR)/$(PYTHON3_SETUPTOOLS_SOURCE)
	mv $(@D)/setuptools-$(PYTHON3_SETUPTOOLS_VERSION)/* $(@D)
	$(RM) -r $(@D)/setuptools-$(PYTHON3_SETUPTOOLS_VERSION)
endef

$(eval $(host-python-package))
