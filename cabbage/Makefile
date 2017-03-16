THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 arm64
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
Cabbage_LDFLAGS += -Wl,-segalign,4000
SHARED_CFLAGS = -fobjc-arc
CFLAGS = -fobjc-arc
ADDITIONAL_OBJCFLAGS = -fobjc-arc
TARGET = iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Cabbage
Cabbage_FILES = Tweak.xm CWStatusBarNotification.m
Cabbage_FRAMEWORKS = UIKit MediaPlayer AudioToolbox CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music"
