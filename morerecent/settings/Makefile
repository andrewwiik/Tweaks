include theos/makefiles/common.mk

BUNDLE_NAME = settings
settings_FILES = settings.mm
settings_INSTALL_PATH = /Library/PreferenceBundles
settings_FRAMEWORKS = UIKit
settings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/settings.plist$(ECHO_END)
