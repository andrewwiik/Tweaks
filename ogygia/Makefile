TARGET = simulator:clang

ARCHS = x86_64
# TARGET = :clang:10.2:latest
# ARCHS = armv7 arm64
Ogygia_CFLAGS = -fobjc-arc -I./headers

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Ogygia
Ogygia_FILES = OGYUIControlCenterVisualEffect.m Tweak.xm
Ogygia_FRAMEWORKS = CoreFoundation Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
