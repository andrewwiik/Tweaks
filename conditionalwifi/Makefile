include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ConditionalWiFi
ConditionalWiFi_CFLAGS = -fobjc-arc
ConditionalWiFi_FILES = Tweak.xm
ConditionalWiFi_FRAMEWORKS = UIKit Foundation SystemConfiguration CoreFoundation
ConditionalWiFi_PRIVATE_FRAMEWORKS = Preferences SpringBoardServices BackBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
