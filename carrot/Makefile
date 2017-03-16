THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 arm64
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
Carrot_LDFLAGS += -Wl,-segalign,4000

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Carrot
Carrot_FILES = Tweak.xm
Carrot_FRAMEWORKS = UIKit QuartzCore
Carrot_PRIVATE_FRAMEWORKS = FuseUI

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
