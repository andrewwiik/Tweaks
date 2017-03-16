GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FastCam
FastCam_FILES = Tweak.xm
FastCam_FRAMEWORKS = IOKit CoreFoundation CoreGraphics AudioToolbox
FastCam_PRIVATE_FRAMEWORKS = IOMobileFramebuffer

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
