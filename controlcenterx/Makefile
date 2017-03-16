# GO_EASY_ON_ME=1
# TARGET = simulator:clang

# ARCHS = x86_64
ARCHS = arm64
Horseshoe_CFLAGS = -fobjc-arc -I./headers
THEOS_DEVICE_IP = 192.168.8.102
THEOS_DEVICE_PORT=22

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Horseshoe
Horseshoe_FILES = JVTransitionAnimator.m $(wildcard *.xm)
Horseshoe_FILES += $(wildcard ICGTransitionAnimation/AnimationControllers/*.m)
Horseshoe_FILES += $(wildcard ICGTransitionAnimation/*.m)
Horseshoe_FILES += CCXSectionObject.m CCXSectionsPanel.m CCXSettingsTableViewCell.m CCXNonTransparentView.m CCXSharedResources.m
Horseshoe_FRAMEWORKS = CoreGraphics QuartzCore UIKit CoreImage
# Horseshoe_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
