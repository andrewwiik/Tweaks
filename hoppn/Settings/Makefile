ARCHS = arm64 armv7

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Hoppin
Hoppin_FILES = Hoppin.mm
Hoppin_INSTALL_PATH = /Library/PreferenceBundles
Hoppin_FRAMEWORKS = UIKit
Hoppin_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Hoppin.plist$(ECHO_END)
