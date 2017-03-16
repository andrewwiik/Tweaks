GO_EASY_ON_ME = 1
export THEOS_BUILD_DIR = deb
ARCHS = armv7 arm64
TARGET_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CustomFT
CustomFT_FILES = Tweak.xm customft/BTOShortCutManager.m customft/BTOAddShortCutViewController.m
CustomFT_FRAMEWORKS = UIKit CoreGraphics
CustomFT_PRIVATE_FRAMEWORKS = SpringBoardServices Preferences
CustomFT_CODESIGN_FLAGS = -Sentitlements.xml
CustomFT_LDFLAGS += -Wl,-segalign,4000

BUNDLE_NAME = kCustomFT
kCustomFT_INSTALL_PATH = /Library/Application Support/CustomFT

include $(THEOS)/makefiles/bundle.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += customft
include $(THEOS_MAKE_PATH)/aggregate.mk
