include $(THEOS)/makefiles/common.mk

Radish_CFLAGS = -fobjc-arc

TWEAK_NAME = Radish
Radish_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Spotify"
