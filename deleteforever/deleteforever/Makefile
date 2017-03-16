TARGET = :clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = DeleteForever
DeleteForever_FILES = DeleteForever.mm $(wildcard *.m)
DeleteForever_INSTALL_PATH = /Library/PreferenceBundles
DeleteForever_FRAMEWORKS = UIKit MessageUI Social CoreGraphics
DeleteForever_PRIVATE_FRAMEWORKS = Preferences
DeleteForever_LDFLAGS = -lMobileGestalt

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DeleteForever.plist$(ECHO_END)
