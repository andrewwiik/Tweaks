include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BDaySpotify
BDaySpotify_USE_SUBSTRATE = 0
BDaySpotify_FILES = tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Spotify"
