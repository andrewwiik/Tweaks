include theos/makefiles/common.mk

BUNDLE_NAME = MoveCellPref
MoveCellPref_FILES = MoveCellPref.mm MoveCellPrefDetailListController.mm
MoveCellPref_INSTALL_PATH = /Library/PreferenceBundles
MoveCellPref_FRAMEWORKS = UIKit
MoveCellPref_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MoveCellPref.plist$(ECHO_END)
