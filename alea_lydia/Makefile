ARCHS = armv7 arm64
TARGET = :clang

include $(THEOS)/makefiles/common.mk
TARGET_LIB_EXT = `-`

TWEAK_NAME = Alea_Lydia
Alea_Lydia_CFLAGS = -fobjc-arc
Alea_Lydia_FILES = $(wildcard *.m)
Alea_Lydia_FRAMEWORKS = UIKit CoreFoundation CoreGraphics QuartzCore
Alea_Lydia_PRIVATE_FRAMEWORKS = Weather
Alea_Lydia_INSTALL_PATH = /var/mobile/Library/Lydia/Views/com.apple.weather/

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/var/mobile/Library/Lydia/Views/com.apple.weather$(ECHO_END)
	$(ECHO_NOTHING)cp Info.plist $(THEOS_STAGING_DIR)/var/mobile/Library/Lydia/Views/com.apple.weather/$(ECHO_END)
	# If your view has some settings uncomment this, otherwise leave commented out
	#$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/var/mobile/Library/Lydia/Views/com.apple.weather/Preferences$(ECHO_END)
	#$(ECHO_NOTHING)cp Preferences/Root.plist $(THEOS_STAGING_DIR)/var/mobile/Library/Lydia/Views/com.apple.weather/Preferences/$(ECHO_END)


after-stage::
	find $(FW_STAGING_DIR) -iname '*.plist' -or -iname '*.strings' -exec plutil -convert binary1 {} \;

after-install::
	install.exec "killall -9 SpringBoard"
