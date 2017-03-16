include $(THEOS)/makefiles/common.mk

CC10_CFLAGS = -fobjc-arc

TWEAK_NAME = CC10
CC10_FILES = WNVibrantStyling.m WNBackdropViewSettings.m Tweak.xm
CC10_FRAMEWORKS = UIKit CoreGraphics QuartzCore
# CC10_PRIVATE_FRAMEWORKS = MobileIcons

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
