include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AirFirm
AirFirm_FILES = Tweak.xm
# AirFirm_PRIVATE_FRAMEWORKS = EAFirmwareUpdater

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
