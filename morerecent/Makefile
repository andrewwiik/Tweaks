GO_EASY_ON_ME = 1
ARCHS = armv7 arm64
MoreRecent_LDFLAGS += -Wl,-segalign,4000
TARGET_CFLAGS = -fobjc-arc
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MoreRecent
MoreRecent_FILES = Tweak.xm
MoreRecent_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music"
SUBPROJECTS += morerecent
include $(THEOS_MAKE_PATH)/aggregate.mk
