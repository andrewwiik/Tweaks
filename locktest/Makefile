GO_EASY_ON_ME = 1

SHARED_CFLAGS = -fobjc-arc

THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 arm64
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LockTest
LockTest_FILES = Tweak.xm LPView.m
LockTest_FRAMEWORKS = EventKit UIKit
LockTest_LDFLAGS = -llockpages

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
