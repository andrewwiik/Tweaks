GO_EASY_ON_ME = 1
export THEOS_BUILD_DIR = deb
ARCHS = armv7 arm64
TARGET_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CustomFT
CustomFT_FILES = CustomFT.mm $(wildcard *.m) $(wildcard *.mm)
CustomFT_INSTALL_PATH = /Library/PreferenceBundles
CustomFT_FRAMEWORKS = UIKit SafariServices CoreGraphics
CustomFT_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CustomFT.plist$(ECHO_END)
