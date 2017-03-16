TARGET = :clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = KeyForce
KeyForce_FILES = KeyForce.mm $(wildcard *.m)
KeyForce_INSTALL_PATH = /Library/PreferenceBundles
KeyForce_FRAMEWORKS = UIKit MessageUI Social CoreGraphics
KeyForce_PRIVATE_FRAMEWORKS = Preferences
KeyForce_LDFLAGS = -lMobileGestalt

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/KeyForce.plist$(ECHO_END)
