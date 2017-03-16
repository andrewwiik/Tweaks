# TARGET = simulator:clang

# THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 arm64
# GO_EASY_ON_ME = 1
# ARCH = x86_64
FINALPACKAGE = 1
SHARED_CFLAGS = -fobjc-arc
CFLAGS = -fobjc-arc
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PeekaBoo
PeekaBoo_FILES = Tweak.xm
PeekaBoo_FRAMEWORKS = UIKit AudioToolbox
PeekaBoo_LIBRARIES = MobileGestalt

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Settings
include $(THEOS_MAKE_PATH)/aggregate.mk
