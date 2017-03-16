TARGET = :clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = musics
musics_FILES = musics.mm $(wildcard *.m)
musics_INSTALL_PATH = /Library/PreferenceBundles
musics_FRAMEWORKS = UIKit MessageUI Social CoreGraphics
musics_PRIVATE_FRAMEWORKS = Preferences
musics_LDFLAGS = -lMobileGestalt

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/musics.plist$(ECHO_END)
