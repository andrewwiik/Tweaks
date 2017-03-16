GO_EASY_ON_ME = 1
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.33.112
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
notetest_LDFLAGS += -Wl,-segalign,4000
TARGET_CFLAGS = -fobjc-arc
notetest_LDFLAGS = -lsqlite3

include theos/makefiles/common.mk

TWEAK_NAME = notetest
notetest_FILES = Tweak.xm NotesView.m
notetest_FRAMEWORKS = UIKit ImageIO AVFoundation QuartzCore CoreVideo CoreMedia CoreGraphics CoreData
notetest_PRIVATE_FRAMEWORKS = SpringBoardUIServices Notes

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
