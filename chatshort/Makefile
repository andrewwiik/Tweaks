GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ChatShort
ChatShort_FILES = Tweak.xm
ChatShort_FRAMEWORKS = UIKit CoreGraphics 
ChatShort_PRIVATE_FRAMEWORKS = ChatKit IMCore SpringBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
