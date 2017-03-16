THEOS_PACKAGE_DIR_NAME = debs
THEOS_DEVICE_IP = 192.168.1.110
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
musictable_CFLAGS = -fobjc-arc
GO_EASY_ON_ME = 1
TARGET = iphone:clang:8.4:6.1
ARCHS = armv7 arm64

include theos/makefiles/common.mk


TWEAK_NAME = musictable
musictable_FILES = $(wildcard *.m *.xm *.x)
musictable_FRAMEWORKS = Foundation UIKit CoreGraphics CoreMotion QuartzCore
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music"
