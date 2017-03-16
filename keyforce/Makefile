THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT=22
FINALPACKAGE = 1
UniversalForce_LDFLAGS += -Wl,-segalign,4000
include theos/makefiles/common.mk

TWEAK_NAME = UniversalForce
UniversalForce_FILES = Tweak.xm
UniversalForce_FRAMEWORKS = UIKit CoreMotion CoreGraphics AudioToolbox MobileCoreServices
UniversalForce_PRIVATE_FRAMEWORKS = ChatKit IMCore AppSupport
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += keyforce
include $(THEOS_MAKE_PATH)/aggregate.mk
