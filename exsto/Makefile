#export THEOS_DEVICE_IP=192.168.0.103
export TARGET=iphone:latest:7.0
export THEOS_DEVICE_IP=10.3.9.121
export ARCHS = armv7 arm64
include $(THEOS)/makefiles/common.mk
export GO_EASY_ON_ME := 1

ADDITIONAL_CFLAGS = -fobjc-arc
TWEAK_NAME = Exsto
Exsto_FILES = Tweak.xm EXSTOCircleMenuView.m CRTXBlurView.m
Exsto_FRAMEWORKS = UIKit CoreGraphics Foundation QuartzCore CoreGraphics CoreImage
Exsto_LIBRARIES = substrate pop
Exsto_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/tweak.mk
THEOS_PACKAGE_BASE_VERSION = 0.0.1.2-1
_THEOS_INTERNAL_PACKAGE_VERSION = 0.0.1.2-1


after-install::
	install.exec "killall -9 SpringBoard"
	#install.exec "killall -9 Preferences"
SUBPROJECTS += exsto
include $(THEOS_MAKE_PATH)/aggregate.mk
