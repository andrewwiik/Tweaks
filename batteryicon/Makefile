THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.33.109
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
include theos/makefiles/common.mk

TWEAK_NAME = BatteryIcon
BatteryIcon_FILES = Tweak.xm
BatteryIcon_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += BatteryIconPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
