ARCHS=armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = music2ls
music2ls_FILES = Tweak.xm
music2ls_FRAMEWORKS = Foundation UIKit CoreGraphics CoreMotion QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Springboard"
