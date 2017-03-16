THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.33.121
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
ADDITIONAL_OBJCFLAGS = -fobjc-arc
SHARED_CFLAGS = -fobjc-arc
include theos/makefiles/common.mk

TWEAK_NAME = qq
qq_LDFlags = -fobjc -arc
qq_FILES = Tweak.xm LEColorPicker.m
qq_FRAMEWORKS = Foundation UIKit CoreGraphics CoreMotion OpenGLES QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
