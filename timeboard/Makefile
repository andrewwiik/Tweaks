include $(THEOS)/makefiles/common.mk
FINALPACKAGE = 1
TWEAK_NAME = TimeBoard
TimeBoard_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += fdf
SUBPROJECTS += dfdf
include $(THEOS_MAKE_PATH)/aggregate.mk
