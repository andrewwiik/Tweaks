THEOS_PACKAGE_DIR_NAME = debs
GO_EASY_ON_ME = 1
ARCHS = armv7 arm64
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.17
THEOS_DEVICE_PORT=22
SwitchService_LDFLAGS += -Wl,-segalign,4000
SHARED_CFLAGS = -fobjc-arc
CFLAGS = -fobjc-arc
ADDITIONAL_OBJCFLAGS = -fobjc-arc
TARGET = iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwitchService
SwitchService_FILES = Tweak.xm PulsingHaloLayer.m
SwitchService_FRAMEWORKS = UIKit CoreMotion CoreGraphics AudioToolbox MobileCoreServices QuartzCore
SwitchService_PRIVATE_FRAMEWORKS = ChatKit IMCore AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileSMS"
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
