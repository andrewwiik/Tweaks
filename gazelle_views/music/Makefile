ARCHS = armv7 arm64
TARGET = :clang

include $(THEOS)/makefiles/common.mk
TARGET_LIB_EXT = -

TWEAK_NAME = Music
Music_FILES = $(wildcard *.m)
Music_FRAMEWORKS = UIKit CoreGraphics
Music_EXTRA_FRAMEWORKS = Gazelle
Music_INSTALL_PATH = /Library/Application Support/Gazelle/Views/com.creatix.gazelle.music/

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.music$(ECHO_END)
	$(ECHO_NOTHING)cp Info.plist $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.music/$(ECHO_END)
	$(ECHO_NOTHING)cp Icon.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.music/$(ECHO_END)
	$(ECHO_NOTHING)cp Icon@2x.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.music/$(ECHO_END)
	$(ECHO_NOTHING)cp Icon@3x.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.music/$(ECHO_END)

	$(ECHO_NOTHING)cp Icon.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.music/$(ECHO_END)
	$(ECHO_NOTHING)cp Icon@2x.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.music/$(ECHO_END)
	$(ECHO_NOTHING)cp Icon@3x.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.music/$(ECHO_END)

	# If your view has some settings uncomment this, otherwise you can remove this
	#$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.music/Preferences$(ECHO_END)
	#$(ECHO_NOTHING)cp Preferences/Root.plist $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.music/Preferences/$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
