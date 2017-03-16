GO_EASY_ON_ME = 1
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.33.112
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
Combine_LDFLAGS += -Wl,-segalign,4000
TARGET_CFLAGS = -fobjc-arc
include theos/makefiles/common.mk

TWEAK_NAME = Combine
Combine_FILES = Tweak.xm
Combine_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
