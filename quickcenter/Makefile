GO_EASY_ON_ME = 1
FINAL_PACKAGE=1
include $(THEOS)/makefiles/common.mk


TWEAK_NAME = QuickCenter
QuickCenter_FILES = CameraView.m FlashLight.m Tweak.xm
QuickCenter_FRAMEWORKS = AudioToolbox UIKit CoreGraphics ImageIO AVFoundation QuartzCore CoreVideo CoreMedia Social
QuickCenter_PRIVATE_FRAMEWORKS = MobileWiFi SpringBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk
after-stage::
	- chmod u+s '$(THEOS_STAGING_DIR)/Library/Application Support/QuickCenter/rootHelper'
after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += quickcenter
SUBPROJECTS += bugHelper
SUBPROJECTS += bugMonitor
SUBPROJECTS += rootHelper
include $(THEOS_MAKE_PATH)/aggregate.mk
