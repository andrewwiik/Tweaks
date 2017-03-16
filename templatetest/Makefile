include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = TemplateTest
TemplateTest_BUNDLE_NAME = com.andrewwiik.templatetest
TemplateTest_BUNDLE_EXTENSION = block
TemplateTest_CFLAGS =  -fobjc-arc
TemplateTest_FILES = $(wildcard *.m)
TemplateTest_FRAMEWORKS = Foundation UIKit
TemplateTest_INSTALL_PATH = /var/mobile/Library/Curago/Widgets/

include $(THEOS_MAKE_PATH)/bundle.mk
