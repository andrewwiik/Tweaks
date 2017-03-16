THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
IMFuck_LDFLAGS += -Wl,-segalign,4000

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IMFuck
IMFuck_FILES = Tweak.xm
IMFuck_PRIVATE_FRAMEWORKS = ChatKit
IMFuck_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
