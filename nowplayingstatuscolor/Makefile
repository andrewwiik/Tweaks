THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.33.128
THEOS_DEVICE_PORT=22
include theos/makefiles/common.mk

TWEAK_NAME = NowPlayingStatusColor
NowPlayingStatusColor_FILES = Tweak.xm
NowPlayingStatusColor_FRAMEWORKS = UIKit


include $(THEOS_MAKE_PATH)/tweak.mk


SUBPROJECTS += statuscolor
include $(THEOS_MAKE_PATH)/aggregate.mk
