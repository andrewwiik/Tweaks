GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CatchMe
CatchMe_FILES = ZKSwizzle.m Tweak.xm
CatchMe_FRAMEWORKS = CoreLocation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 PokemonGO"
