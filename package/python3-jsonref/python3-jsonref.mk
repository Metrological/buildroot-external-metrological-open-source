################################################################################
#
# python-jsonref
#
################################################################################

PYTHON3_JSONREF_VERSION = 0.3.0
PYTHON3_JSONREF_SOURCE = jsonref-$(PYTHON3_JSONREF_VERSION).tar.gz
PYTHON3_JSONREF_SITE = https://files.pythonhosted.org/packages/2f/d0/8b97b067d5083812bd1b0facebe39c2b392e5e2d95d9caadc2bb1104fce4
PYTHON3_JSONREF_LICENSE = MIT
PYTHON3_JSONREF_LICENSE_FILES = COPYING json/LICENSE
PYTHON3_JSONREF_SETUP_TYPE = setuptools

HOST_PYTHON3_JSONREF_NEEDS_HOST_PYTHON = python3
HOST_PYTHON3_JSONREF_DL_SUBDIR = python-jsonref

$(eval $(host-python-package))

