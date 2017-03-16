include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iVarTest
iVarTest_FILES = Tweak.mm
iVarTest_FRAMEWORKS = UIKit Foundation CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
