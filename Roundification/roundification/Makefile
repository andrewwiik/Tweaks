ARCHS = armv7 arm64
GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Roundification
Roundification_FILES = Roundification.mm BetterPSSliderTableCell.mm
Roundification_INSTALL_PATH = /Library/PreferenceBundles
Roundification_FRAMEWORKS = UIKit
Roundification_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Roundification.plist$(ECHO_END)
