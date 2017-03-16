ARCHS = arm64 armv7


include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MoreRecent
MoreRecent_FILES = MoreRecent.mm
MoreRecent_INSTALL_PATH = /Library/PreferenceBundles
MoreRecent_FRAMEWORKS = UIKit
MoreRecent_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MoreRecent.plist$(ECHO_END)
