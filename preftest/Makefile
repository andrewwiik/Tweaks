THEOS_PACKAGE_DIR_NAME = debs
THEOS_DEVICE_IP = 192.168.1.110
THEOS_DEVICE_PORT=22
ARCHS = arm64 armv7

include theos/makefiles/common.mk

TWEAK_NAME = MoveCelll
MoveCelll_FILES = Tweak.xm
MoveCelll_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += movecellpref
include $(THEOS_MAKE_PATH)/aggregate.mk
