include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PokemonLock
PokemonLock_FILES = Tweak.xm $(wildcard *.mm)
PokemonLock_FRAMEWORKS = UIKit CoreGraphics 
#PokemonLock_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
