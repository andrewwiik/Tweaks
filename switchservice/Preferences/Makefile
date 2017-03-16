ARCHS = arm64 armv7

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SwitchService
SwitchService_FILES = SwitchService.mm
SwitchService_INSTALL_PATH = /Library/PreferenceBundles
SwitchService_FRAMEWORKS = UIKit
SwitchService_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SwitchService.plist$(ECHO_END)
