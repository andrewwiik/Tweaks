TARGET = :clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = deleteforeverpref
deleteforeverpref_FILES = deleteforeverpref.mm $(wildcard *.m)
deleteforeverpref_INSTALL_PATH = /Library/PreferenceBundles
deleteforeverpref_FRAMEWORKS = UIKit MessageUI Social CoreGraphics
deleteforeverpref_PRIVATE_FRAMEWORKS = Preferences
deleteforeverpref_LDFLAGS = -lMobileGestalt

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/deleteforeverpref.plist$(ECHO_END)
