THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
TARGET = iphone:clang:latest:8.4
KeyForce_LDFLAGS += -Wl,-segalign,4000
include theos/makefiles/common.mk

TWEAK_NAME = NoBlueMic
NoBlueMic_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
