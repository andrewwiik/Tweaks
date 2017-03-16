GO_EASY_ON_ME = 1
ARCHS = armv7 armv7s arm64
FINALPACKAGE = 1
PointAndShoot_LDFLAGS += -Wl,-segalign,4000
TARGET_CFLAGS = -fobjc-arc

include theos/makefiles/common.mk

TWEAK_NAME = PointAndShoot
PointAndShoot_FILES = Tweak.xm CameraView.m CornerHighlightView.m
PointAndShoot_FRAMEWORKS = UIKit ImageIO AVFoundation QuartzCore CoreVideo CoreMedia CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += settings
include $(THEOS_MAKE_PATH)/aggregate.mk
