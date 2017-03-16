TOOL_NAME = bugHelper
bugHelper_INSTALL_PATH = /Library/Application Support/QuickCenter
bugHelper_FILES = \
    ../common/crashlog_util.m \
    ../common/exec_as_root.m \
    main.m
bugHelper_LDFLAGS = -lcrashreport
bugHelper_PRIVATE_FRAMEWORKS = SpringBoardServices
bugHelper_CODESIGN_FLAGS="-SEntitlements.plist"

include $(THEOS_MAKE_PATH)/common.mk
include $(THEOS_MAKE_PATH)/tool.mk

after-clean::
	- rm -rf $(THEOS_PROJECT_DIR)/notifier/Common
	- rm -rf $(THEOS_PROJECT_DIR)/notifier/common
