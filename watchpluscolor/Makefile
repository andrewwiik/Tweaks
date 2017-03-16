include $(THEOS)/makefiles/common.mk

WatchPlusColor_CFLAGS = -fobjc-arc

TWEAK_NAME = WatchPlusColor
WatchPlusColor_FILES = Tweak.xm
WatchPlusColor_FRAMEWORKS = UIKit CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
