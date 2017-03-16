TARGET = :clang
ARCHS = armv7 armv7s arm64
include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp BatteryIconPrefs.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BatteryIconPrefs.plist$(ECHO_END)
	$(ECHO_NOTHING)cp *.png $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(ECHO_END)
