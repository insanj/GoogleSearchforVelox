include theos/makefiles/common.mk

BUNDLE_NAME = GoogleVelox
GoogleVelox_FILES = GoogleVeloxFolderView.mm
GoogleVelox_INSTALL_PATH = /Library/Velox/Plugins/
GoogleVelox_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"