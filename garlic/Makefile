include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Garlic
Garlic_CFLAGS = -fobjc-arc
Garlic_FILES = Tweak.xm
Garlic_FRAMEWORKS = CoreGraphics UIKit


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
