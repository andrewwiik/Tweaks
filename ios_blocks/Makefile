SDK = 9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iOS_Blocks
iOS_Blocks_FILES = UIImage+StackBlur.m SBWDXPlaceholderIcon.xm Tweak.xm IBIconHandler.m
iOS_Blocks_FRAMEWORKS = UIKit CoreGraphics QuartzCore CoreFoundation
iOS_Blocks_PRIVATE_FRAMEWORKS = FuseUI
iOS_Blocks_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
