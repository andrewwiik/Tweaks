GO_EASY_ON_ME = 1
THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 arm64
bunny_LDFLAGS += -Wl,-segalign,4000

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = bunny
bunny_FILES = Tweak.xm $(wildcard Apps/*.xm)
bunny_FRAMEWORKS = UIKit CoreGraphics MobileCoreServices QuartzCore
bunny_PRIVATE_FRAMEWORKS = ChatKit IMCore AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Tumblr"
include $(THEOS_MAKE_PATH)/aggregate.mk
