TARGET = simulator:clang

ARCHS = x86_64
# ARCHS = armv7 arm64
controlcenterx9_CFLAGS = -fobjc-arc -I./headers

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = controlcenterx9
controlcenterx9_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
