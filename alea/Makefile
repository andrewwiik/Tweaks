include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Alea
Alea_CFLAGS = -fobjc-arc
Alea_FILES = $(wildcard ThirdParty/*.m) $(wildcard Weather/*.m) $(wildcard Stocks/*.m) $(wildcard Stocks/*.xm) $(wildcard Notes/*.xm) $(wildcard Notes/*.m) Tweak.xm
Alea_FRAMEWORKS = UIKit CoreFoundation Foundation CoreGraphics
Alea_PRIVATE_FRAMEWORKS = Weather SpringBoardServices Stocks

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
