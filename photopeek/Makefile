THEOS_PACKAGE_DIR_NAME = debs
musictable_CFLAGS = -fobjc-arc
SHARED_CFLAGS = -fobjc-arc
ADDITIONAL_OBJCFLAGS = -fobjc-arc
GO_EASY_ON_ME = 1
TARGET = iphone:clang:8.4:6.1
ARCHS = armv7s arm64
THEOS_DEVICE_IP = 192.168.1.124
THEOS_DEVICE_PORT=22
include theos/makefiles/common.mk

TWEAK_NAME = PhotoPeek
PhotoPeek_FILES = Tweak.xm CNPPopupController.m
PhotoPeek_FRAMEWORKS = UIKit PhotosUI QuartzCore CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileSlideShow"
