include $(THEOS)/makefiles/common.mk

CellularProfiles_CFLAGS = -fobjc-arc

TWEAK_NAME = CellularProfiles
CellularProfiles_FILES = $(wildcard XL/*.m) Tweak.xm
CellularProfiles_FRAMEWORKS = UIKit CoreGraphics CoreFoundation Foundation QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences"
