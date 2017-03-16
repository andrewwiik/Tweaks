GO_EASY_ON_ME = 1
ARCHS = armv7 arm64
FINALPACKAGE = 0
TARGET_CFLAGS = -fobjc-arc


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = QuickSugar
QuickSugar_FILES = Tweak.xm
QuickSugar_FRAMEWORKS = UIKit HealthKitUI
QuickSugar_PRIVATE_FRAMEWORKS = SpringBoardServices HealthKitUI
QuickSugar_LDFLAGS = -Wl
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
