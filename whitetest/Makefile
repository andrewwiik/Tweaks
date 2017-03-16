# TARGET = simulator:clang

# ARCHS = x86_64

WhiteTest_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WhiteTest
WhiteTest_FILES = Tweak.xm


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
