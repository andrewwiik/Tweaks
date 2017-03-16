ARCHS = armv7 arm64
TARGET = :clang

include $(THEOS)/makefiles/common.mk
TARGET_LIB_EXT = -

TWEAK_NAME = Weather
Weather_FILES = $(wildcard *.m)
Weather_FRAMEWORKS = UIKit CoreFoundation CoreGraphics QuartzCore
Weather_PRIVATE_FRAMEWORKS = Weather WeatherUI
Weather_EXTRA_FRAMEWORKS = Gazelle
Weather_INSTALL_PATH = /Library/Application Support/Gazelle/Views/com.creatix.gazelle.weather/

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.weather$(ECHO_END)
	$(ECHO_NOTHING)cp Info.plist $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.weather/$(ECHO_END)
	$(ECHO_NOTHING)cp Icon.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.weather/$(ECHO_END)
	$(ECHO_NOTHING)cp Icon@2x.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.weather/$(ECHO_END)
	$(ECHO_NOTHING)cp Icon@3x.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.weather/$(ECHO_END)

	$(ECHO_NOTHING)cp Icon.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.weather/$(ECHO_END)
	$(ECHO_NOTHING)cp Icon@2x.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.weather/$(ECHO_END)
	$(ECHO_NOTHING)cp Icon@3x.png $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.weather/$(ECHO_END)

	# If your view has some settings uncomment this, otherwise you can remove this
	#$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.weather/Preferences$(ECHO_END)
	#$(ECHO_NOTHING)cp Preferences/Root.plist $(THEOS_STAGING_DIR)/Library/Application\ Support/Gazelle/Views/com.creatix.gazelle.weather/Preferences/$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
