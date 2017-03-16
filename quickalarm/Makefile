GO_EASY_ON_ME = 1
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.118
THEOS_DEVICE_PORT=22
ARCHS = armv7 arm64
TARGET_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = QuickAlarm
QuickAlarm_FILES = Tweak.xm
QuickAlarm_FRAMEWORKS = UIKit CoreGraphics
QuickAlarm_PRIVATE_FRAMEWORKS = SpringBoardServices
QuickAlarm_CODESIGN_FLAGS = -Sentitlements.xml
QuickAlarm_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"