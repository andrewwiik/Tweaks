include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ccmaskfix
ccmaskfix_CFLAGS = -fobjc-arc -I./headers
ccmaskfix_FILES = Tweak.xm
ccmaskfix_FRAMEWORKS = CoreGraphics CoreImage QuartzCore UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
