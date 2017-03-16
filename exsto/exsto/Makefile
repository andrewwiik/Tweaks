ARCHS = arm64 armv7
GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

ADDITIONAL_CFLAGS = -fobjc-arc
BUNDLE_NAME = exsto
exsto_FILES = exsto.mm BetterPSSliderTableCell.mm HeaderCell.mm FooterCell.mm
exsto_INSTALL_PATH = /Library/PreferenceBundles
exsto_FRAMEWORKS = UIKit
exsto_PRIVATE_FRAMEWORKS = Preferences
ADDITIONAL_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/exsto.plist$(ECHO_END)
