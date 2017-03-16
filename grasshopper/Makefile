include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Grasshopper
Grasshopper_FILES = Tweak.xm
Grasshopper_LIBRARIES = MobileGestalt

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
