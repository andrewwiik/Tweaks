include $(THEOS)/makefiles/common.mk

TWEAK_NAME = lol2
lol2_FILES = Tweak.xm
lol2_FRAMEWORKS = UIKit QuartzCore CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences"
