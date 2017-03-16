include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GridSwitcher
GridSwitcher_FILES = Tweak.xm
GridSwitcher_FRAMEWORKS = QuartzCore CoreGraphics
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
