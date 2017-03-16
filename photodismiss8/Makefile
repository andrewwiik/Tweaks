
THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.1.110
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
include theos/makefiles/common.mk

TWEAK_NAME = PhotoDismiss8
PhotoDismiss8_FRAMEWORKS = Foundation UIKit CoreGraphics CoreMotion QuartzCore
PhotoDismiss8_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Photos"
