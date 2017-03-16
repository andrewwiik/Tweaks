THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
FINALPACKAGE = 1
include theos/makefiles/common.mk

TWEAK_NAME = StillHere
StillHere_FILES = Tweak.xm
StillHere_FRAMEWORKS = Foundation UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 InCallService"
