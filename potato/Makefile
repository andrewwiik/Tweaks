GO_EASY_ON_ME = 1
export THEOS_BUILD_DIR = deb
ARCHS = armv7 arm64
TARGET_CFLAGS = -fobjc-arc

include theos/makefiles/common.mk

TWEAK_NAME = Potato
Potato_FILES = Tweak.xm BTAVRCP_ActivatorEvents.m
Potato_FRAMEWORKS = UIKit
Potato_CODESIGN_FLAGS = -Sentitlements.xml
Potato_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
