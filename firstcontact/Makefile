include $(THEOS)/makefiles/common.mk


FirstContact_CFLAGS = -fobjc-arc

TWEAK_NAME = FirstContact
FirstContact_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Messages"
