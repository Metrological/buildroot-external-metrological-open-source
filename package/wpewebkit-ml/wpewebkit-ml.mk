################################################################################
#
# WPEWebKit
#
################################################################################

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML2_22),y)
WPEWEBKIT_ML_VERSION_VALUE = 2.22
WPEWEBKIT_ML_VERSION = 57ceb0847df838aab61dc42c291025d923641417
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML2_28),y)  
WPEWEBKIT_ML_VERSION_VALUE = 2.28
WPEWEBKIT_ML_VERSION = 649cbb3e183987e8395461caa4301363143923ce
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML2_38),y)  
WPEWEBKIT_ML_VERSION_VALUE = 2.38
WPEWEBKIT_ML_VERSION = e066cb2870a82f61eb307a621dfb3c6604b4a84f
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML2_42),y)
WPEWEBKIT_ML_VERSION_VALUE = 2.42
WPEWEBKIT_ML_VERSION = 4781435000038f97baf127bf26103ac2bf62febc
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML2_46),y)
WPEWEBKIT_ML_VERSION_VALUE = 2.46
WPEWEBKIT_ML_VERSION = c9fcaa083e872074fa8599d1d5a1fa0e0441abcf
endif

WPEWEBKIT_ML_SITE = $(call github,WebPlatformForEmbedded,WPEWebKit,$(WPEWEBKIT_ML_VERSION))

WPEWEBKIT_ML_INSTALL_STAGING = YES
WPEWEBKIT_ML_LICENSE = LGPL-2.1+, BSD-2-Clause
WPEWEBKIT_ML_LICENSE_FILES = \
	Source/WebCore/LICENSE-APPLE \
	Source/WebCore/LICENSE-LGPL-2.1

WPEWEBKIT_ML_DEPENDENCIES = host-gperf host-python3 host-ruby \
	harfbuzz cairo icu jpeg libepoxy libgcrypt libgles libtasn1 \
	libpng libxslt openjpeg webp wpebackend host-unifdef

WPEWEBKIT_ML_CMAKE_BACKEND = ninja

# Oldskool way, kept here just for reference
# WPEWEBKIT_ML_CONF_OPTS = \
#		-GNinja \
#		-DCMAKE_MAKE_PROGRAM="$(HOST_DIR)/bin/ninja" \
#
# WPEWEBKIT_ML_DEPENDENCIES += host-ninja

WPEWEBKIT_ML_CONF_OPTS += \
	-DPORT=WPE \
	-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
	-DENABLE_ACCELERATED_2D_CANVAS=ON

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_CMAKE_VERBOSE),y)
WPEWEBKIT_ML_CONF_OPTS += -DCMAKE_VERBOSE_MAKEFILE=ON
endif


WPEWEBKIT_ML_PARALLEL_BUILD_JOBS = $(call qstrip,$(BR2_PACKAGE_WPEWEBKIT_ML_PARALLEL_BUILD_JOBS))

ifneq ($(WPEWEBKIT_ML_PARALLEL_BUILD_JOBS),)
WPEWEBKIT_ML_NINJA_OPTS += -j$(WPEWEBKIT_ML_PARALLEL_BUILD_JOBS)
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_DISABLE_UNIFIED_BUILDS),y)
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_UNIFIED_BUILDS=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML2_22),y)
WPEWEBKIT_ML_CONF_OPTS += \
	-DENABLE_DATABASE_PROCESS=OFF \
	-DENABLE_DEVICE_ORIENTATION=OFF \
	-DENABLE_FETCH_API=OFF \
	-DENABLE_FTL_JIT=OFF \
	-DENABLE_FULLSCREEN_API=OFF \
	-DENABLE_GAMEPAD=OFF \
	-DENABLE_GEOLOCATION=OFF \
	-DENABLE_INDEXED_DATABASE=OFF \
	-DENABLE_MATHML=OFF \
	-DENABLE_MEDIA_STATISTICS=OFF \
	-DENABLE_METER_ELEMENT=OFF \
	-DENABLE_NOTIFICATIONS=OFF \
	-DENABLE_SAMPLING_PROFILER=ON \
	-DENABLE_SUBTLE_CRYPTO=OFF \
	-DENABLE_SVG_FONTS=OFF \
	-DENABLE_TOUCH_EVENTS=OFF \
	-DENABLE_VIDEO=ON \
	-DENABLE_VIDEO_TRACK=ON \
	-DENABLE_WEBASSEMBLY=OFF \
	-DEXPORT_DEPRECATED_WEBKIT2_C_API=ON

WPEWEBKIT_ML_DEPENDENCIES += gstreamer1 gst1-plugins-base \
	gst1-plugins-good gst1-plugins-bad libsoup 

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_ENABLE_NATIVE_VIDEO),y)
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_NATIVE_VIDEO=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_NATIVE_VIDEO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_ENABLE_NATIVE_AUDIO),y)
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_NATIVE_AUDIO=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_NATIVE_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_ENABLE_TEXT_SINK),y)
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_TEXT_SINK=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_TEXT_SINK=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_USE_WEB_AUDIO),y)
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_WEB_AUDIO=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_WEB_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_ENABLE_MEDIA_SOURCE),y)
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_MEDIA_SOURCE=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_MEDIA_SOURCE=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_USE_ENCRYPTED_MEDIA),y)
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_ENCRYPTED_MEDIA=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_CDMI),y)
WPEWEBKIT_ML_DEPENDENCIES += thunder-clientlibraries
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_OPENCDM=ON
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_USE_GSTREAMER_GL),y)
WPEWEBKIT_ML_CONF_OPTS += -DUSE_GSTREAMER_GL=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DUSE_GSTREAMER_GL=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_USE_GSTREAMER_WEBKIT_HTTP_SRC),y)
WPEWEBKIT_ML_CONF_OPTS += -DUSE_GSTREAMER_WEBKIT_HTTP_SRC=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DUSE_GSTREAMER_WEBKIT_HTTP_SRC=OFF
endif

endif

ifeq ($(filter y,$(BR2_PACKAGE_WPEWEBKIT_ML2_28)\
				,$(BR2_PACKAGE_WPEWEBKIT_ML2_38)\
				,$(BR2_PACKAGE_WPEWEBKIT_ML2_42)\
				,$(BR2_PACKAGE_WPEWEBKIT_ML2_46)),)

WPEWEBKIT_ML_DEPENDENCIES += libsoup3

WPEWEBKIT_ML_CONF_OPTS += \
	-DENABLE_ACCESSIBILITY=OFF \
	-DENABLE_API_TESTS=OFF \
	-DENABLE_BUBBLEWRAP_SANDBOX=OFF \
	-DENABLE_MINIBROWSER=OFF \
	-DUSE_WOFF2=OFF

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML2_28),y)
WPEWEBKIT_ML_CONF_OPTS += \
	-DSILENCE_CROSS_COMPILATION_NOTICES=ON
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML2_42),y)
WPEWEBKIT_ML_CONF_OPTS += \
	-DUSE_JPEGXL=OFF \
	-DUSE_AVIF=OFF \
	-DUSE_GBM=OFF \
	-DUSE_GSTREAMER_TRANSCODER=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_MULTIMEDIA),y)
WPEWEBKIT_ML_CONF_OPTS += \
	-DENABLE_VIDEO=ON \
	-DENABLE_MEDIA_SOURCE=ON \
	-DENABLE_ENCRYPTED_MEDIA=ON \
	-DENABLE_MEDIA_STATISTICS=ON \
	-DENABLE_WEB_AUDIO=ON \
	-DENABLE_MODERN_MEDIA_CONTROLS=ON \
	-DENABLE_MEDIA_CONTROLS_SCRIPT=ON \
	-DENABLE_VIDEO_USES_ELEMENT_FULLSCREEN=ON \
	-DENABLE_MEDIA_CONTROLS_CONTEXT_MENUS=ON

WPEWEBKIT_ML_DEPENDENCIES += gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad

ifeq ($(BR2_PACKAGE_THUNDER_CLIENTLIBRARIES)$(BR2_PACKAGE_THUNDER_CDMI),yy)
WPEWEBKIT_ML_DEPENDENCIES += thunder-clientlibraries
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_THUNDER=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_THUNDER=OFF
endif

else
WPEWEBKIT_ML_CONF_OPTS += \
	-DENABLE_VIDEO=OFF \
	-DENABLE_MEDIA_SOURCE=OFF \
	-DENABLE_ENCRYPTED_MEDIA=OFF \
	-DENABLE_THUNDER=OFF \
	-DENABLE_WEB_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_USE_GSTREAMER_GL),y)
WPEWEBKIT_ML_CONF_OPTS += -DUSE_GSTREAMER_GL=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DUSE_GSTREAMER_GL=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_WEBRTC),y)
WPEWEBKIT_ML_DEPENDENCIES += gst1-plugins-bad openssl
WPEWEBKIT_ML_CONF_OPTS += \
	-DENABLE_WEB_RTC=ON \
	-DENABLE_MEDIA_STREAM=ON \
	-DENABLE_MEDIA_RECORDER=ON \
	-DUSE_GSTREAMER_TRANSCODER=ON \
	-DUSE_GSTREAMER_WEBRTC=ON
endif

endif

ifeq ($(filter y,$(BR2_PACKAGE_WPEWEBKIT_ML2_38)\
                ,$(BR2_PACKAGE_WPEWEBKIT_ML2_42)\
                ,$(BR2_PACKAGE_WPEWEBKIT_ML2_46)),y)

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_JOURNALD_LOG=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_JOURNALD_LOG=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_ENABLE_NATIVE_VIDEO),y)
WPEWEBKIT_ML_CONF_OPTS += -DUSE_GSTREAMER_NATIVE_VIDEO=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DUSE_GSTREAMER_NATIVE_VIDEO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_ENABLE_NATIVE_AUDIO),y)
WPEWEBKIT_ML_CONF_OPTS += -DUSE_GSTREAMER_NATIVE_AUDIO=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DUSE_GSTREAMER_NATIVE_AUDIO=OFF
endif

endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_SYMBOLS_NO),y)
WPEWEBKIT_ML_SYMBOL_FLAGS = -g0
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_SYMBOLS_LEVEL_1),y)
WPEWEBKIT_ML_SYMBOL_FLAGS = -g1 -gsplit-dwarf
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_SYMBOLS_LEVEL_2),y)
WPEWEBKIT_ML_SYMBOL_FLAGS = -g2 -gsplit-dwarf
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_SYMBOLS_LEVEL_3),y)
WPEWEBKIT_ML_SYMBOL_FLAGS = -g3 -gsplit-dwarf
endif

WPEWEBKIT_ML_BUILD_TYPE = Release
WPEWEBKIT_ML_CXXFLAGS = -O2 -DNDEBUG
ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_DEBUG),y)
WPEWEBKIT_ML_BUILD_TYPE = Debug
WPEWEBKIT_ML_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
WPEWEBKIT_ML_CXXFLAGS = -O0
endif

WPEWEBKIT_ML_COMPILER_FLAGS=$(WPEWEBKIT_ML_SYMBOL_FLAGS) $(WPEWEBKIT_ML_CXXFLAGS) -Wno-cast-align
WPEWEBKIT_ML_CONF_OPTS += \
	-DCMAKE_C_FLAGS_RELEASE="$(WPEWEBKIT_ML_COMPILER_FLAGS)" \
	-DCMAKE_CXX_FLAGS_RELEASE="$(WPEWEBKIT_ML_COMPILER_FLAGS)" \
	-DCMAKE_C_FLAGS_DEBUG="$(WPEWEBKIT_ML_COMPILER_FLAGS)" \
	-DCMAKE_CXX_FLAGS_DEBUG="$(WPEWEBKIT_ML_COMPILER_FLAGS)"

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_USE_PUNCH_HOLE_GSTREAMER),y)
WPEWEBKIT_ML_CONF_OPTS += -DUSE_HOLE_PUNCH_GSTREAMER=ON -DUSE_GSTREAMER_HOLEPUNCH=ON
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_USE_PUNCH_HOLE_EXTERNAL),y)
WPEWEBKIT_ML_CONF_OPTS += -DUSE_HOLE_PUNCH_EXTERNAL=ON -DUSE_EXTERNAL_HOLEPUNCH=ON
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML_WEBDRIVER),y)
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_WEBDRIVER=ON
else
WPEWEBKIT_ML_CONF_OPTS += -DENABLE_WEBDRIVER=OFF
endif

ifeq ($(BR2_PACKAGE_WESTEROS),y)
WPEWEBKIT_ML_DEPENDENCIES += westeros
WPEWEBKIT_ML_CONF_OPTS += -DUSE_WPEWEBKIT_ML_PLATFORM_WESTEROS=ON
ifeq ($(BR2_PACKAGE_WESTEROS_SINK),y)
WPEWEBKIT_ML_DEPENDENCIES += westeros-sink
WPEWEBKIT_ML_CONF_OPTS += \
	-DUSE_GSTREAMER_HOLEPUNCH=ON \
	-DUSE_HOLE_PUNCH_GSTREAMER=ON \
	-DUSE_WESTEROS_SINK=ON
else
WPEWEBKIT_ML_CONF_OPTS += \
	-DUSE_GSTREAMER_HOLEPUNCH=OFF \
	-DUSE_HOLE_PUNCH_GSTREAMER=OFF
endif
else ifeq ($(BR2_PACKAGE_HAS_NEXUS),y)
WPEWEBKIT_ML_CONF_OPTS += -DUSE_WPEWEBKIT_ML_PLATFORM_BCM_NEXUS=ON
else ifeq ($(BR2_PACKAGE_HORIZON_SDK),y)
WPEWEBKIT_ML_CONF_OPTS += -DUSE_WPEWEBKIT_ML_PLATFORM_INTEL_CE=ON
else ifeq ($(BR2_PACKAGE_INTELCE_SDK),y)
WPEWEBKIT_ML_CONF_OPTS += -DUSE_WPEWEBKIT_ML_PLATFORM_INTEL_CE=ON
else ifeq ($(BR2_PACKAGE_RPI_FIRMWARE),y)
WPEWEBKIT_ML_CONF_OPTS += -DUSE_WPEWEBKIT_ML_PLATFORM_RPI=ON
endif

# JIT is not supported for MIPS r6, but the WebKit build system does not
# have a check for these processors. The same goes for ARMv5 and ARMv6.
# Disable JIT forcibly here and use the CLoop interpreter instead.
#
# Also, we have to disable the sampling profiler and WebAssembly, which
# do NOT work with ENABLE_C_LOOP.
#
# Upstream bugs: https://bugs.webkit.org/show_bug.cgi?id=191258
#                https://bugs.webkit.org/show_bug.cgi?id=172765
#                https://bugs.webkit.org/show_bug.cgi?id=265218
#
ifeq ($(BR2_ARM_CPU_ARMV5)$(BR2_ARM_CPU_ARMV6)$(BR2_MIPS_CPU_MIPS32R6)$(BR2_MIPS_CPU_MIPS64R6),y)
WPEWEBKIT_ML_CONF_OPTS += \
	-DENABLE_JIT=OFF \
	-DENABLE_C_LOOP=ON \
	-DENABLE_SAMPLING_PROFILER=OFF \
	-DENABLE_WEBASSEMBLY=OFF
endif

define WPEWEBKIT_ML_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(WPEWEBKIT_ML_NINJA_ENV) \
		$(BR2_CMAKE) --build $(WPEWEBKIT_ML_BUILDDIR) -- $(NINJA_OPTS) $(WPEWEBKIT_ML_NINJA_OPTS)
endef

define WPEWEBKIT_ML_INSTALL_CMDS
	$(TARGET_MAKE_ENV) $(WPEWEBKIT_ML_NINJA_ENV) \
		$(BR2_CMAKE) --install $(WPEWEBKIT_ML_BUILDDIR)
endef

define WPEWEBKIT_ML_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(WPEWEBKIT_ML_NINJA_ENV) DESTDIR=$(STAGING_DIR) \
		$(BR2_CMAKE) --install $(WPEWEBKIT_ML_BUILDDIR)
endef

define WPEWEBKIT_ML_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(WPEWEBKIT_ML_MAKE_ENV) DESTDIR=$(TARGET_DIR) \
		$(BR2_CMAKE) --install $(WPEWEBKIT_ML_BUILDDIR)
endef

$(eval $(cmake-package))
