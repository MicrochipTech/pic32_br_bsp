#############################################################
#
# PIC32 stage1 Bootloader
#
#############################################################
STAGE1_VERSION = 8c85406ad4a08bc33815f51014082404a27b3095
STAGE1_SITE = $(call github,MicrochipTech,stage1,$(STAGE1_VERSION))
STAGE1_LICENSE = Apache-2.0
STAGE1_LICENSE_FILES = LICENSE
STAGE1_INSTALL_TARGET = NO
STAGE1_INSTALL_STAGING = YES
STAGE1_DEPENDENCIES = uboot

define STAGE1_BUILD_CMDS
	$(@D)/stage1.X/compile.sh $(BINARIES_DIR)
endef

define STAGE1_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/stage1.X/dist/pic32mzda/production/stage1.X.production.unified.hex $(BINARIES_DIR)
endef

$(eval $(generic-package))

.PHONY: flash
flash: stage1
	$(BUILD_DIR)/stage1-*/stage1.X/flash.sh
