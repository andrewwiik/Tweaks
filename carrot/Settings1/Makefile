TARGET = :clang
ARCHS = armv7 arm64
include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp Carrot.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Carrot.plist$(ECHO_END)
	$(ECHO_NOTHING)cp *.png $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(ECHO_END)
