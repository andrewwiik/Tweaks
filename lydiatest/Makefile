export TARGET=iphone:latest:7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LydiaTest
LydiaTest_CFLAGS = -fobjc-arc
LydiaTest_FILES = Tweak.xm
LydiaTest_FRAMEWORKS = UIKit CoreGraphics QuartzCore CoreFoundation Foundation CoreImage CoreMedia
LydiaTest_LIBRARIES = pop


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
