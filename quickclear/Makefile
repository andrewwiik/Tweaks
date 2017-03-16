GO_EASY_ON_ME = 1
THEOS_PACKAGE_DIR_NAME = debs
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.118
THEOS_DEVICE_PORT=22
export THEOS_BUILD_DIR = deb
ARCHS = armv7 arm64
TARGET_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = QuickClear
QuickClear_FILES = Tweak.xm
QuickClear_FRAMEWORKS = UIKit CoreGraphics
QuickClear_PRIVATE_FRAMEWORKS = SpringBoardServices
QuickClear_CODESIGN_FLAGS = -Sentitlements.xml
QuickClear_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"