include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DopeLock
DopeLock_FILES = dopelockRootListController.m dopelockMakersListController.m SKPersonCell.m
DopeLock_INSTALL_PATH = /Library/PreferenceBundles
DopeLock_FRAMEWORKS = UIKit Social CoreFoundation Foundation CoreGraphics
DopeLock_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DopeLock.plist$(ECHO_END)
