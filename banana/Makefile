include $(THEOS)/makefiles/common.mk
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 4.3
TWEAK_NAME = Banana
Banana_CFLAGS = -fobjc-arc
Banana_FILES = BNHourlyView.m Tweak.xm Settings.xm
Banana_FRAMEWORKS = UIKit CoreGraphics CoreLocation AppSupport
Banana_PRIVATE_FRAMEWORKS = Weather

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += banana
include $(THEOS_MAKE_PATH)/aggregate.mk
