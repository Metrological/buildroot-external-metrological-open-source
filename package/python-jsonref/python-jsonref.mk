################################################################################
#
# python-jsonref
#
################################################################################

PYTHON_JSONREF_VERSION = 1.0.1
PYTHON_JSONREF_SOURCE = jsonref-$(PYTHON_JSONREF_VERSION).tar.gz
PYTHON_JSONREF_SITE = https://files.pythonhosted.org/packages/be/ee/e737a6ce8372b8a86c6e775b720f8eca67a1b63a830957c4c750d1e7bb46
PYTHON_JSONREF_LICENSE = MIT
PYTHON_JSONREF_LICENSE_FILES = COPYING json/LICENSE
PYTHON_JSONREF_SETUP_TYPE = pep517
HOST_PYTHON_JSONREF_DEPENDENCIES = host-python-poetry-core
PYTHON_JSONREF_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
