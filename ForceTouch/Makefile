include theos/makefiles/common.mk

TWEAK_NAME = FBGestureTest
FBGestureTest_FILES = Tweak.xm
FBGestureTest_FRAMEWORKS = UIKit CoreGraphics 
FBGestureTest_PRIVATE_FRAMEWORKS = IOKit BackBoardServices AudioToolbox
#FBGestureTest_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
