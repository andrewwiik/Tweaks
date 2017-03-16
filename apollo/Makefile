THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.33.128
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
include theos/makefiles/common.mk

TWEAK_NAME = Apollo
Apollo_FILES = Tweak.xm
Apollo_FRAMEWORKS = Foundation UIKit CoreGraphics CoreMotion QuartzCore MediaPlayer AVKit AVFoundation MediaRemote Celestial
Apollo_PRIVATE_FRAMEWORKS = FuseUI StoreKitUI

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += apollo
include $(THEOS_MAKE_PATH)/aggregate.mk
