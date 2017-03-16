GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WiFiTest
WiFiTest_FILES = Tweak.xm
WiFiTest_PRIVATE_FRAMEWORKS = SpringBoardServices
# WiFiTest_LIBRARIES = applist
# WiFiTest_LIBRARIES = libsystem_network

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 networkd"
