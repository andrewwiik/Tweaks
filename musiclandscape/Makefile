THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.1.110
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
include theos/makefiles/common.mk

TWEAK_NAME = MusicLandscape
MusicLandscape_FILES = Tweak.xm
MusicLandscape_FRAMEWORKS = Foundation UIKit CoreGraphics CoreMotion QuartzCore MediaPlayer
MusicLandscape_PRIVATE_FRAMEWORKS = FuseUI

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music"
