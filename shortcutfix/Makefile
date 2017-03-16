GO_EASY_ON_ME = 1
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
ShortcutFix_LDFLAGS += -Wl,-segalign,4000
TARGET_CFLAGS = -fobjc-arc


include theos/makefiles/common.mk

TWEAK_NAME = ShortcutFix
ShortcutFix_FILES = Tweak.xm
ShortcutFix_FRAMEWORKS = UIKit CoreMotion CoreGraphics AudioToolbox MobileCoreServices
ShortcutFix_PRIVATE_FRAMEWORKS = ChatKit IMCore AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
