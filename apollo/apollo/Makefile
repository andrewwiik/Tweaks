TARGET = :clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = Apollo
Apollo_FILES = Apollo.mm $(wildcard *.m)
Apollo_INSTALL_PATH = /Library/PreferenceBundles
Apollo_FRAMEWORKS = UIKit MessageUI Social CoreGraphics
Apollo_PRIVATE_FRAMEWORKS = Preferences
Apollo_LDFLAGS = -lMobileGestalt

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Apollo.plist$(ECHO_END)
