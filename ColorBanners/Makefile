export ARCHS = armv7 arm64
export TARGET = iphone:9.2:9.2
export THEOS_PACKAGE_DIR_NAME = debs
# PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)~beta$(VERSION.INC_BUILD_NUMBER)
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ColorBanners
ColorBanners_FILES = Tweak.xm CBRGradientView.m UIColor+ColorBanners.m CBRPrefsManager.m CBRAppList.m
ColorBanners_FILES += CBRColorCache.m CBRReadabilityManager.m
# ColorBanners_FILES += private/*.m
ColorBanners_FRAMEWORKS = UIKit CoreGraphics QuartzCore
ColorBanners_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += colorbannersprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
