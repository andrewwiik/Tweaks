TARGET = :clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = StatusColor
StatusColor_FILES = StatusColor.mm $(wildcard *.m)
StatusColor_INSTALL_PATH = /Library/PreferenceBundles
StatusColor_FRAMEWORKS = UIKit MessageUI Social CoreGraphics
StatusColor_PRIVATE_FRAMEWORKS = Preferences
StatusColor_LDFLAGS = -lMobileGestalt

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/StatusColor.plist$(ECHO_END)
