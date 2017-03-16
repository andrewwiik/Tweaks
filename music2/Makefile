ARCHS=armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = music2
music2_FILES = Tweak.xm
music2_FRAMEWORKS = Foundation UIKit CoreGraphics CoreMotion MediaPlayerUI
music2_PRIVATE_FRAMEWORKS = MediaPlayerUI

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music"
SUBPROJECTS += musics
include $(THEOS_MAKE_PATH)/aggregate.mk
