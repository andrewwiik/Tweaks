THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 arm64
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
RoundItOut_LDFLAGS += -Wl,-segalign,4000
include theos/makefiles/common.mk

TWEAK_NAME = RoundItOut
RoundItOut_FILES = Tweak.xm
RoundItOut_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
