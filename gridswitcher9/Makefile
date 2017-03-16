# GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GridSwitcher9
GridSwitcher9_CFLAGS = -fobjc-arc
GridSwitcher9_FILES = Tweak.xm CRTXGridSwitcherCollectionViewItemViewCell.mm CRTXGridSwitcherCollectionViewController.mm
GridSwitcher9_FRAMEWORKS = UIKit Foundation QuartzCore CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
