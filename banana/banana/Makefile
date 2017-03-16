include $(THEOS)/makefiles/common.mk
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 9.0
BUNDLE_NAME = Banana
Banana_FILES = $(wildcard *.m)
Banana_INSTALL_PATH = /Library/PreferenceBundles
Banana_FRAMEWORKS = UIKit AdSupport AudioToolbox AVFoundation CoreGraphics CoreMedia CoreLocation CoreTelephony EventKit EventKitUI MediaPlayer MessageUI QuartzCore Social StoreKit SystemConfiguration
Banana_PRIVATE_FRAMEWORKS = Preferences Weather
Banana_EXTRA_FRAMEWORKS = GoogleMobileAds
Banana_LIBRARIES = crashreport packageinfo

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Banana.plist$(ECHO_END)
