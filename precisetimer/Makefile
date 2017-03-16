THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.33.107
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1

include theos/makefiles/common.mk

TWEAK_NAME = PreciseTimer
PreciseTimer_FILES = Tweak.xm
PreciseTimer_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileTimer"
