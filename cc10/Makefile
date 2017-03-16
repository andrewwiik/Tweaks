include $(THEOS)/makefiles/common.mk

NotificationsX_CFLAGS = -fobjc-arc

TWEAK_NAME = NotificationsX
NotificationsX_FILES = UIImage+Extra.m NTXVibrantStyling.m NTXBackdropViewSettings.m NTXMaterialView.m NTXNotificationListCellActionButton.m NTXModernNotificationView.m Tweak.xm
NotificationsX_FRAMEWORKS = UIKit CoreGraphics QuartzCore CoreFoundation CoreText
NotificationsX_PRIVATE_FRAMEWORKS = SpringBoardServices


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
