include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ViewButton
ViewButton_FILES = Tweak.xm
ViewButton_PRIVATE_FRAMEWORKS = UserNotificationsUIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
