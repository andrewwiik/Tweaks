ARCHS = armv7 arm64
UniversalForce_CFLAGS = -fobjc-arc -I./headers

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UniversalForce
UniversalForce_FILES = Tweak.xm
UniversalForce_PRIVATE_FRAMEWORKS = IOKit AppSupport
UniversalForce_LIBRARIES = MobileGestalt

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
 