GO_EASY_ON_ME = 1

SHARED_CFLAGS = -fobjc-arc

THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 arm64
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22

include theos/makefiles/common.mk

TWEAK_NAME = Tonus
Tonus_FILES = Tweak.xm
Tonus_FRAMEWORKS = AudioToolbox

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
