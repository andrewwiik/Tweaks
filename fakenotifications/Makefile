TARGET = simulator:clang

ARCHS = x86_64
FakeNotifications_CFLAGS = -fobjc-arc -I./headers

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FakeNotifications
FakeNotifications_FILES = Tweak.xm
FakeNotifications_FRAMEWORKS = CoreFoundation UIKit Foundation
FakeNotifications_PRIVATE_FRAMEWORKS = BulletinBoard

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
