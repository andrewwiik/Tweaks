SHARED_CFLAGS = -fobjc-arc

THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 arm64
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DopeLock
DopeLock_FILES = Tweak.xm dopeLockObject.m LPView.m LPViewController.m
DopeLock_FRAMEWORKS = EventKit UIKit
DopeLock_LDFLAGS = -llockpages

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += dopelock
include $(THEOS_MAKE_PATH)/aggregate.mk