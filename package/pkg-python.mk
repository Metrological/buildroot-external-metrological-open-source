################################################################################
# Python package infrastructure
#
# This file implements an infrastructure that eases development of
# package .mk files for Python packages. It should be used for all
# packages that use Python setup.py/setuptools as their build system.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this Python infrastructure requires the
# .mk file to only specify metadata information about the package:
# name, version, download URL, etc.
#
# We still allow the package .mk file to override what the different
# steps are doing, if needed. For example, if <PKG>_BUILD_CMDS is
# already defined, it is used as the list of commands to perform to
# build the package, instead of the default Python behaviour. The
# package can also define some post operation hooks.
#
################################################################################

ifeq ($(BR2_arm)$(BR2_armeb),y)
PKG_PYTHON_ARCH = arm
else
PKG_PYTHON_ARCH = $(ARCH)
endif
PKG_PYTHON_HOST_PLATFORM = linux-$(PKG_PYTHON_ARCH)

# basename does not evaluate if a file exists, so we must check to ensure
# the _sysconfigdata__linux_*.py file exists. The "|| true" is added to return
# an empty string if the file does not exist.
PKG_PYTHON_SYSCONFIGDATA_PATH = $(PYTHON3_PATH)/_sysconfigdata__linux_*.py
PKG_PYTHON_SYSCONFIGDATA_NAME = `{ [ -e $(PKG_PYTHON_SYSCONFIGDATA_PATH) ] && basename $(PKG_PYTHON_SYSCONFIGDATA_PATH) .py; } || true`

# Target python packages
PKG_PYTHON_ENV = \
	_PYTHON_HOST_PLATFORM="$(PKG_PYTHON_HOST_PLATFORM)" \
	_PYTHON_PROJECT_BASE="$(PYTHON3_DIR)" \
	_PYTHON_SYSCONFIGDATA_NAME="$(PKG_PYTHON_SYSCONFIGDATA_NAME)" \
	PATH=$(BR_PATH) \
	$(TARGET_CONFIGURE_OPTS) \
	PYTHONPATH="$(PYTHON3_PATH)" \
	PYTHONNOUSERSITE=1 \
	_python_sysroot=$(STAGING_DIR) \
	_python_prefix=/usr \
	_python_exec_prefix=/usr

# Host python packages
HOST_PKG_PYTHON_ENV = \
	PATH=$(BR_PATH) \
	PYTHONNOUSERSITE=1 \
	$(HOST_CONFIGURE_OPTS)

# Target distutils-based packages
PKG_PYTHON_DISTUTILS_ENV = \
	$(PKG_PYTHON_ENV) \
	LDSHARED="$(TARGET_CROSS)gcc -shared"

PKG_PYTHON_DISTUTILS_BUILD_OPTS = \
	--executable=/usr/bin/python

PKG_PYTHON_DISTUTILS_INSTALL_OPTS = \
	--install-headers=/usr/include/python$(PYTHON3_VERSION_MAJOR) \
	--prefix=/usr

PKG_PYTHON_DISTUTILS_INSTALL_TARGET_OPTS = \
	$(PKG_PYTHON_DISTUTILS_INSTALL_OPTS) \
	--root=$(TARGET_DIR)

PKG_PYTHON_DISTUTILS_INSTALL_STAGING_OPTS = \
	$(PKG_PYTHON_DISTUTILS_INSTALL_OPTS) \
	--root=$(STAGING_DIR)

# Host distutils-based packages
HOST_PKG_PYTHON_DISTUTILS_ENV = \
	$(HOST_PKG_PYTHON_ENV)

HOST_PKG_PYTHON_DISTUTILS_INSTALL_OPTS = \
	--prefix=$(HOST_DIR)

# Target setuptools-based packages
PKG_PYTHON_SETUPTOOLS_ENV = \
	$(PKG_PYTHON_ENV)

PKG_PYTHON_SETUPTOOLS_CMD = \
	$(if $(wildcard $($(PKG)_BUILDDIR)/setup.py),setup.py,-c 'from setuptools import setup;setup()')

PKG_PYTHON_SETUPTOOLS_INSTALL_OPTS = \
	--install-headers=/usr/include/python$(PYTHON3_VERSION_MAJOR) \
	--prefix=/usr \
	--executable=/usr/bin/python \
	--single-version-externally-managed

PKG_PYTHON_SETUPTOOLS_INSTALL_TARGET_OPTS = \
	$(PKG_PYTHON_SETUPTOOLS_INSTALL_OPTS) \
	--root=$(TARGET_DIR)

PKG_PYTHON_SETUPTOOLS_INSTALL_STAGING_OPTS = \
	$(PKG_PYTHON_SETUPTOOLS_INSTALL_OPTS) \
	--root=$(STAGING_DIR)

# Host setuptools-based packages
HOST_PKG_PYTHON_SETUPTOOLS_ENV = \
	$(HOST_PKG_PYTHON_ENV)

HOST_PKG_PYTHON_SETUPTOOLS_INSTALL_OPTS = \
	--prefix=$(HOST_DIR) \
	--root=/ \
	--single-version-externally-managed

# Target setuptools-rust-based packages
PKG_PYTHON_SETUPTOOLS_RUST_ENV = \
	$(PKG_PYTHON_SETUPTOOLS_ENV) \
	$(PKG_CARGO_ENV) \
	PYO3_CROSS_LIB_DIR="$(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)"

# Host setuptools-rust-based packages
HOST_PKG_PYTHON_SETUPTOOLS_RUST_ENV = \
	$(HOST_PKG_PYTHON_SETUPTOOLS_ENV) \
	$(HOST_PKG_CARGO_ENV) \
	PYO3_CROSS_LIB_DIR="$(HOST_DIR)/lib/python$(PYTHON3_VERSION_MAJOR)"

# Target pep517-based packages
PKG_PYTHON_PEP517_ENV = \
	$(PKG_PYTHON_ENV)

PKG_PYTHON_PEP517_INSTALL_OPTS = \
	--interpreter=/usr/bin/python \
	--script-kind=posix

PKG_PYTHON_PEP517_INSTALL_TARGET_OPTS = \
	$(PKG_PYTHON_PEP517_INSTALL_OPTS) \
	--purelib=$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages \
	--headers=$(TARGET_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR) \
	--scripts=$(TARGET_DIR)/usr/bin \
	--data=$(TARGET_DIR)/usr

PKG_PYTHON_PEP517_INSTALL_STAGING_OPTS = \
	$(PKG_PYTHON_PEP517_INSTALL_OPTS) \
	--purelib=$(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages \
	--headers=$(STAGING_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR) \
	--scripts=$(STAGING_DIR)/usr/bin \
	--data=$(STAGING_DIR)/usr

# Host pep517-based packages
HOST_PKG_PYTHON_PEP517_ENV = \
	$(HOST_PKG_PYTHON_ENV)

HOST_PKG_PYTHON_PEP517_INSTALL_OPTS = \
	--interpreter=$(HOST_DIR)/bin/python \
	--script-kind=posix \
	--purelib=$(HOST_DIR)/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages \
	--headers=$(HOST_DIR)/include/python$(PYTHON3_VERSION_MAJOR) \
	--scripts=$(HOST_DIR)/bin \
	--data=$(HOST_DIR)

HOST_PKG_PYTHON_PEP517_BOOTSTRAP_INSTALL_OPTS = \
	--installdir=$(HOST_DIR)/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages

# Target maturin packages
PKG_PYTHON_MATURIN_ENV = \
	$(PKG_PYTHON_PEP517_ENV) \
	$(PKG_CARGO_ENV) \
	PYO3_CROSS_LIB_DIR="$(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)"

# Host maturin packages
HOST_PKG_PYTHON_MATURIN_ENV = \
	$(HOST_PKG_PYTHON_PEP517_ENV) \
	$(HOST_PKG_CARGO_ENV) \
	PYO3_CROSS_LIB_DIR="$(HOST_DIR)/lib/python$(PYTHON3_VERSION_MAJOR)"

################################################################################
# inner-python-package -- defines how the configuration, compilation
# and installation of a Python package should be done, implements a
# few hooks to tune the build process and calls the generic package
# infrastructure to generate the necessary make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################

define inner-python-package

ifndef $(2)_SETUP_TYPE
 ifdef $(3)_SETUP_TYPE
  $(2)_SETUP_TYPE = $$($(3)_SETUP_TYPE)
 else
  $$(error "$(2)_SETUP_TYPE must be set")
 endif
endif

# Distutils
ifeq ($$($(2)_SETUP_TYPE),distutils)
ifeq ($(4),target)
$(2)_BASE_ENV = $$(PKG_PYTHON_DISTUTILS_ENV)
$(2)_BASE_BUILD_CMD = setup.py build
$(2)_BASE_BUILD_OPTS = $$(PKG_PYTHON_DISTUTILS_BUILD_OPTS)
$(2)_BASE_INSTALL_TARGET_CMD  = setup.py install --no-compile $$(PKG_PYTHON_DISTUTILS_INSTALL_TARGET_OPTS)
$(2)_BASE_INSTALL_STAGING_CMD = setup.py install $$(PKG_PYTHON_DISTUTILS_INSTALL_STAGING_OPTS)
else
$(2)_BASE_ENV         = $$(HOST_PKG_PYTHON_DISTUTILS_ENV)
$(2)_BASE_BUILD_CMD   = setup.py build
$(2)_BASE_INSTALL_CMD = setup.py install $$(HOST_PKG_PYTHON_DISTUTILS_INSTALL_OPTS)
endif
# Setuptools
else ifneq ($$(filter setuptools setuptools-rust,$$($(2)_SETUP_TYPE)),)
ifeq ($(4),target)
ifeq ($$($(2)_SETUP_TYPE),setuptools-rust)
$(2)_BASE_ENV = $$(PKG_PYTHON_SETUPTOOLS_RUST_ENV)
else
$(2)_BASE_ENV = $$(PKG_PYTHON_SETUPTOOLS_ENV)
endif
$(2)_BASE_BUILD_CMD = $$(PKG_PYTHON_SETUPTOOLS_CMD) build
$(2)_BASE_INSTALL_TARGET_CMD = $$(PKG_PYTHON_SETUPTOOLS_CMD) install --no-compile $$(PKG_PYTHON_SETUPTOOLS_INSTALL_TARGET_OPTS)
$(2)_BASE_INSTALL_STAGING_CMD = $$(PKG_PYTHON_SETUPTOOLS_CMD) install $$(PKG_PYTHON_SETUPTOOLS_INSTALL_STAGING_OPTS)
else
ifeq ($$($(2)_SETUP_TYPE),setuptools-rust)
$(2)_BASE_ENV = $$(HOST_PKG_PYTHON_SETUPTOOLS_RUST_ENV)
else
$(2)_BASE_ENV = $$(HOST_PKG_PYTHON_SETUPTOOLS_ENV)
endif
$(2)_BASE_BUILD_CMD = $$(PKG_PYTHON_SETUPTOOLS_CMD) build
$(2)_BASE_INSTALL_CMD = $$(PKG_PYTHON_SETUPTOOLS_CMD) install $$(HOST_PKG_PYTHON_SETUPTOOLS_INSTALL_OPTS)
endif
else ifneq ($$(filter flit maturin pep517,$$($(2)_SETUP_TYPE)),)
ifeq ($(4),target)
ifeq ($$($(2)_SETUP_TYPE),maturin)
$(2)_BASE_ENV = $$(PKG_PYTHON_MATURIN_ENV)
else
$(2)_BASE_ENV = $$(PKG_PYTHON_PEP517_ENV)
endif
$(2)_BASE_BUILD_CMD = -m build -n -w
$(2)_BASE_INSTALL_TARGET_CMD = $(TOPDIR)/support/scripts/pyinstaller.py dist/* $$(PKG_PYTHON_PEP517_INSTALL_TARGET_OPTS)
$(2)_BASE_INSTALL_STAGING_CMD = $(TOPDIR)/support/scripts/pyinstaller.py dist/* $$(PKG_PYTHON_PEP517_INSTALL_STAGING_OPTS)
else
ifeq ($$($(2)_SETUP_TYPE),maturin)
$(2)_BASE_ENV = $$(HOST_PKG_PYTHON_MATURIN_ENV)
else
$(2)_BASE_ENV = $$(HOST_PKG_PYTHON_PEP517_ENV)
endif
$(2)_BASE_BUILD_CMD = -m build -n -w
$(2)_BASE_INSTALL_CMD = $(TOPDIR)/support/scripts/pyinstaller.py dist/* $$(HOST_PKG_PYTHON_PEP517_INSTALL_OPTS)
endif
else ifeq ($$($(2)_SETUP_TYPE),flit-bootstrap)
ifeq ($(4),target)
$$(error flit-bootstrap setup type only supported for host packages)
else
$(2)_BASE_ENV = $$(HOST_PKG_PYTHON_PEP517_ENV)
$(2)_BASE_BUILD_CMD = -m flit_core.wheel
$(2)_BASE_INSTALL_CMD ?= $(TOPDIR)/support/scripts/pyinstaller.py dist/* $$(HOST_PKG_PYTHON_PEP517_INSTALL_OPTS)
endif
else
$$(error "Invalid $(2)_SETUP_TYPE. Valid options are 'distutils', 'maturin', 'setuptools', 'setuptools-rust', 'pep517' or 'flit'.")
endif

# We need to vendor the Cargo crates at download time for pyo3 based
# packages.
#
ifneq ($$(filter maturin setuptools-rust,$$($(2)_SETUP_TYPE)),)
ifeq ($(4),target)
$(2)_DL_ENV = $$(PKG_CARGO_ENV)
else
$(2)_DL_ENV = $$(HOST_PKG_CARGO_ENV)
endif
ifndef $(2)_CARGO_MANIFEST_PATH
ifdef $(3)_CARGO_MANIFEST_PATH
$(2)_DL_ENV += BR_CARGO_MANIFEST_PATH=$$($(3)_CARGO_MANIFEST_PATH)
else
ifneq ($$($(2)_SUBDIR),)
$(2)_DL_ENV += BR_CARGO_MANIFEST_PATH=$$($(2)_SUBDIR)/Cargo.toml
endif
endif
else
$(2)_DL_ENV += BR_CARGO_MANIFEST_PATH=$$($(2)_CARGO_MANIFEST_PATH)
endif
endif

# Target packages need both the python interpreter on the target (for
# runtime) and the python interpreter on the host (for
# compilation). However, host packages only need the python
# interpreter on the host.
#
ifeq ($(4),target)
$(2)_DEPENDENCIES += host-python3 python3
else
$(2)_DEPENDENCIES += host-python3
endif # ($(4),target)

# Setuptools based packages will need setuptools for the host Python
# interpreter (both host and target).
#
ifneq ($$(filter setuptools setuptools-rust,$$($(2)_SETUP_TYPE)),)
$(2)_DEPENDENCIES += host-python-setuptools
ifeq ($$($(2)_SETUP_TYPE),setuptools-rust)
$(2)_DEPENDENCIES += host-python-setuptools-rust
endif
else ifneq ($$(filter flit maturin pep517,$$($(2)_SETUP_TYPE)),)
$(2)_DEPENDENCIES += host-python-pypa-build host-python-installer
ifeq ($$($(2)_SETUP_TYPE),flit)
$(2)_DEPENDENCIES += host-python-flit-core
endif
ifeq ($$($(2)_SETUP_TYPE),maturin)
$(2)_DEPENDENCIES += host-python-maturin
endif
else ifeq ($$($(2)_SETUP_TYPE),flit-bootstrap)
# Don't add dependency on host-python-installer for
# host-python-installer itself, and its dependencies.
ifeq ($$(filter host-python-flit-core host-python-installer,$(1)),)
$(2)_DEPENDENCIES += host-python-installer
endif
endif

# Pyo3 based packages(setuptools-rust and maturin) will need rust
# toolchain dependencies for the host Python interpreter (both host
# and target).
#
ifneq ($$(filter maturin setuptools-rust,$$($(2)_SETUP_TYPE)),)
$(2)_DEPENDENCIES += host-rustc
$(2)_DOWNLOAD_POST_PROCESS = cargo
$(2)_DOWNLOAD_DEPENDENCIES = host-rustc
endif # SETUP_TYPE

#
# Build step. Only define it if not already defined by the package .mk
# file.
#
ifndef $(2)_BUILD_CMDS
define $(2)_BUILD_CMDS
	(cd $$($$(PKG)_BUILDDIR)/; \
		$$($$(PKG)_BASE_ENV) $$($$(PKG)_ENV) \
		$$(HOST_DIR)/bin/python3 \
		$$($$(PKG)_BASE_BUILD_CMD) \
		$$($$(PKG)_BASE_BUILD_OPTS) $$($$(PKG)_BUILD_OPTS))
endef
endif

#
# Host installation step. Only define it if not already defined by the
# package .mk file.
#
ifndef $(2)_INSTALL_CMDS
define $(2)_INSTALL_CMDS
	(cd $$($$(PKG)_BUILDDIR)/; \
		$$($$(PKG)_BASE_ENV) $$($$(PKG)_ENV) \
		$$(HOST_DIR)/bin/python3 \
		$$($$(PKG)_BASE_INSTALL_CMD) \
		$$($$(PKG)_INSTALL_OPTS))
endef
endif

#
# Target installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	(cd $$($$(PKG)_BUILDDIR)/; \
		$$($$(PKG)_BASE_ENV) $$($$(PKG)_ENV) \
		$$(HOST_DIR)/bin/python3 \
		$$($$(PKG)_BASE_INSTALL_TARGET_CMD) \
		$$($$(PKG)_INSTALL_TARGET_OPTS))
endef
endif

#
# Staging installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_STAGING_CMDS
define $(2)_INSTALL_STAGING_CMDS
	(cd $$($$(PKG)_BUILDDIR)/; \
		$$($$(PKG)_BASE_ENV) $$($$(PKG)_ENV) \
		$$(HOST_DIR)/bin/python3 \
		$$($$(PKG)_BASE_INSTALL_STAGING_CMD) \
		$$($$(PKG)_INSTALL_STAGING_OPTS))
endef
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef

################################################################################
# python-package -- the target generator macro for Python packages
################################################################################

python-package = $(call inner-python-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
host-python-package = $(call inner-python-package,host-$(pkgname),$(call UPPERCASE,host-$(pkgname)),$(call UPPERCASE,$(pkgname)),host)
