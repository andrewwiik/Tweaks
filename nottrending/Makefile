THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 arm64
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
NotTrending_LDFLAGS += -Wl,-segalign,4000

include theos/makefiles/common.mk

TWEAK_NAME = NotTrending
NotTrending_FILES = Tweak.xm
NotTrending_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 YouTube"
