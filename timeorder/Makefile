
GO_EASY_ON_ME =1
THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.1.116
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
TARGET = iphone:clang:latest:8.4
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TimeOrder
TimeOrder_FILES = Tweak.xm
TimeOrder_PRIVATE_FRAMEWORKS = IMCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileSMS"
