#
# Radmind package manifest for Entware
#

include $(TOPDIR)/rules.mk

PKG_NAME:=radmind
PKG_VERSION:=1.16.1
PKG_RELEASE:=1
PKG_FIXUP:=autoreconf
PKG_FIXUP:=patch-libtool

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/voretaq7/radmind.git
PKG_SOURCE_VERSION:=d959404958a9a840550cd3681e824dd8fa938122
PKG_MIRROR_HASH:=skip

#include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

define Package/libsnet
  SECTION:=libs
  CATEGORY:=Network
  DEPENDS:=+libopenssl
  TITLE:=sNET library
endef

define Package/libsnet/description
    A networking library with support for SSL.
endef

define Package/radmind
  TITLE:=Radmind server
  DEPENDS:=+libopenssl +libsasl2
endef

define Package/radmind/Default
  SUBMENU:=Extra packages
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Radmind server
endef

define Package/radmind/description
    The server components of Radmind.
endef

CONFIGURE_ARGS += --prefix=/opt --with-ssl=$(STAGING_DIR)/opt

define Build/Prepare
	$(PKG_UNPACK)
	(cd $(PKG_BUILD_DIR) && autoreconf -i && \
        cd libsnet && autoreconf -i \
    	)
	$(Build/Patch)
endef

define Build/Compile
	(cd $(PKG_BUILD_DIR) && sed -i 's/^INCPATH=\(.*\)-I\/usr\/include\(.*\)/INCPATH=\1 \2/' Makefile )
	$(call Build/Compile/Default)
endef


define Package/radmind/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lcksum $(1)/opt/bin/lcksum
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lmerge $(1)/opt/bin/lmerge
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lsort $(1)/opt/bin/lsort
	$(INSTALL_DIR) $(1)/opt/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/radmind $(1)/opt/sbin/radmind
endef

$(eval $(call BuildPackage,libsnet))
$(eval $(call BuildPackage,radmind,+libopenssl))
