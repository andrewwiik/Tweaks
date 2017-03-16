include $(THEOS)/makefiles/common.mk

TWEAK_NAME = togglescroll
togglescroll_FILES = Tweak.xm
togglescroll_FRAMEWORKS = UIKit AudioToolbox
togglescroll_LIBRARIES = MobileGestalt

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
