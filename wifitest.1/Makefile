GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WiFiTest1
WiFiTest1_FILES = Tweak.xm
WiFiTest1_LIBRARIES = applist
# WiFiTest_LIBRARIES = libsystem_network

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 networkd"
