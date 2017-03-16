GO_EASY_ON_ME=1
CCFLAGS += -stdlib=libc++ -std=c++11
LDFLAGS = -lc++
TARGET = iphone:clang:latest:latest
include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = IBKKit
IBKKit_OBJ_FILES = ThirdParty/PINRemoteImage/libPINRemoteImage.a ThirdParty/PINCache/libPINCache.a ThirdParty/AsyncDisplayKit/libAsyncDisplayKit.a
IBKKit_FILES = IBKKit.mm
IBKKit_INSTALL_PATH = /Library/Frameworks

include $(THEOS_MAKE_PATH)/framework.mk
