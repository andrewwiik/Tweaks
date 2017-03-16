THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.1.117
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
IMHack_LDFLAGS += -Wl,-segalign,4000
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IMHack
IMHack_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
