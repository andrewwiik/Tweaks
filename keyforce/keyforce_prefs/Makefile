include theos/makefiles/common.mk

BUNDLE_NAME = keyforce_prefs
keyforce_prefs_FILES = keyforce_prefs.mm
keyforce_prefs_INSTALL_PATH = /Library/PreferenceBundles
keyforce_prefs_FRAMEWORKS = UIKit
keyforce_prefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/keyforce_prefs.plist$(ECHO_END)
