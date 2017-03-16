ARCHS = arm64 armv7

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PeekaBoo
PeekaBoo_FILES = PeekaBoo.mm
PeekaBoo_INSTALL_PATH = /Library/PreferenceBundles
PeekaBoo_FRAMEWORKS = UIKit
PeekaBoo_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PeekaBoo.plist$(ECHO_END)
