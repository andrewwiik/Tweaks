GO_EASY_ON_ME = 1
THEOS_BUILD_DIR = test
SHARED_CFLAGS = -fobjc-arc
CFLAGS = -fobjc-arc
ADDITIONAL_OBJCFLAGS = -fobjc-arc
include $(THEOS)/makefiles/common.mk
THEOS_BUILD_DIR = test
BUNDLE_NAME = quickcenter
quickcenter_FILES = $(wildcard *.m)
quickcenter_INSTALL_PATH = /Library/PreferenceBundles
quickcenter_FRAMEWORKS = UIKit Social MobileCoreServices CoreGraphics SafariServices
quickcenter_PRIVATE_FRAMEWORKS = Preferences AccountsUI
quickcenter_LIBRARIES = crashreport packageinfo
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/quickcenter.plist$(ECHO_END)
