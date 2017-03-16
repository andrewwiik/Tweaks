GO_EASY_ON_ME = 1
THEOS_PACKAGE_DIR_NAME = debs
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Floater
Floater_FILES = Tweak.xm Floater.m CDTContextHostProvider.mm FloaterRootViewController.m
Floater_FRAMEWORKS = UIKit CoreGraphics QuartzCore
Floater_PRIVATE_FRAMEWORKS = SpringBoardServices
Floater_CODESIGN_FLAGS = -Sentitlements.xml
Floater_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
