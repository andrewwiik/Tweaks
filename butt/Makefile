include theos/makefiles/common.mk

TWEAK_NAME = butt
butt_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Butt"
