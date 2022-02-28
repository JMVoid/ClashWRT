include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-clashwrt
PKG_VERSION:=0.0.1
PKG_RELEASE:=beta
PKG_MAINTAINER:=JMVoid <https://github.com/jmvoid/ClashWRT>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI support for clash
	PKGARCH:=all
	DEPENDS:=+iptables +dnsmasq-full +coreutils +coreutils-nohup +bash +curl +ca-certificates +ipset +ip-full +iptables-mod-tproxy +iptables-mod-extra +libcap +libcap-bin +ruby +ruby-yaml +kmod-tun
	MAINTAINER:=JMVoid
endef

define Package/$(PKG_NAME)/description
    A LuCI support for clash
endef

define Build/Prepare
	$(CP) $(CURDIR)/root $(PKG_BUILD_DIR)
	$(CP) $(CURDIR)/luasrc $(PKG_BUILD_DIR)
	$(foreach po,$(wildcard ${CURDIR}/po/zh-cn/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
	chmod 0755 $(PKG_BUILD_DIR)/root/etc/init.d/clashwrt
	chmod -R 0755 $(PKG_BUILD_DIR)/root/usr/share/clashwrt/
	mkdir -p $(PKG_BUILD_DIR)/root/etc/clashwrt/config
	mkdir -p $(PKG_BUILD_DIR)/root/etc/clashwrt/backup
	mkdir -p $(PKG_BUILD_DIR)/root/etc/clashwrt/core
	mkdir -p $(PKG_BUILD_DIR)/root/usr/share/clashwrt/backup
	cp -f "$(PKG_BUILD_DIR)/root/etc/config/clashwrt" "$(PKG_BUILD_DIR)/root/usr/share/clashwrt/backup/clashwrt" >/dev/null 2>&1
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/conffiles
endef

define Package/$(PKG_NAME)/preinst
#!/bin/sh
if [ -f "/etc/config/clashwrt" ]; then
	cp -f "/etc/config/clashwrt" "/tmp/clashwrt.bak" >/dev/null 2>&1
	cp -rf "/etc/clashwrt" "/tmp/clashwrt" >/dev/null 2>&1
fi
endef

define Package/$(PKG_NAME)/postinst
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
	uci -q set clashwrt.config.enable=0
	uci -q commit clashwrt
	cp -f "/etc/config/clashwrt" "/tmp/clashwrt.bak" >/dev/null 2>&1
	cp -rf "/etc/clashwrt" "/tmp/clashwrt" >/dev/null 2>&1
endef

define Package/$(PKG_NAME)/postrm
#!/bin/sh
	rm -rf /etc/clashwrt
	rm -rf /tmp/clashwrt.log
	rm -rf /tmp/clashwrt_start.log
	rm -rf /tmp/clashwrt_last_version
	rm -rf /tmp/clashwrt_config.tmp
	rm -rf /tmp/clashwrt.change
	rm -rf /tmp/Proxy_Group
	rm -rf /tmp/rules_name
	rm -rf /tmp/rule_providers_name
	rm -rf /tmp/clash_last_version
	rm -rf /usr/share/clashwrt/backup
	rm -rf /tmp/clashwrt_fake_filter.list
	rm -rf /tmp/clashwrt_servers_fake_filter.conf
	uci -q delete firewall.clashwrt
	uci -q commit firewall
	uci -q delete ucitrack.@clashwrt[-1]
	uci -q commit ucitrack
	rm -rf /tmp/luci-*
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/*.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(CP) $(PKG_BUILD_DIR)/root/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luasrc/* $(1)/usr/lib/lua/luci/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
