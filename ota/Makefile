GO_EASY_ON_ME = 1
SHARED_CFLAGS = -fobjc-arc
CFLAGS = -fobjc-arc
ADDITIONAL_OBJCFLAGS = -fobjc-arc
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ota
ota_FILES = TRVSEventSource/TRVSEventSource.m TRVSEventSource/TRVSServerSentEvent.m Tweak.xm
ota-FRAMEWORKS = Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
