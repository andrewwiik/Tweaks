include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Asparagus
Asparagus_CFLAGS = -fobjc-arc
Asparagus_FILES = Tweak.xm
Asparagus_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music"
