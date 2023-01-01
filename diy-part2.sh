#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

VERSION="V3.4"


cat > version.patch  <<EOF
--- a/package/base-files/files/etc/banner
+++ b/package/base-files/files/etc/banner
@@ -5,5 +5,5 @@
 |___|__|_|  /__|_|  /\____/|__|   |__| (____  /____/
           \/      \/  BE FREE AND UNAFRAID  \/
  -----------------------------------------------------
- %D %V, %C
+ %D $VERSION By Zan, %C
  -----------------------------------------------------

--- a/package/base-files/files/etc/openwrt_release
+++ b/package/base-files/files/etc/openwrt_release
@@ -1,7 +1,7 @@
 DISTRIB_ID='%D'
-DISTRIB_RELEASE='%V'
+DISTRIB_RELEASE='$VERSION By Zan'
 DISTRIB_REVISION='%R'
 DISTRIB_TARGET='%S'
 DISTRIB_ARCH='%A'
-DISTRIB_DESCRIPTION='%D %V %C'
+DISTRIB_DESCRIPTION='%D $VERSION By Zan %C'
 DISTRIB_TAINTS='%t'

--- a/package/base-files/files/usr/lib/os-release
+++ b/package/base-files/files/usr/lib/os-release
@@ -1,8 +1,8 @@
 NAME="%D"
-VERSION="%V"
+VERSION="$VERSION By Zan"
 ID="%d"
 ID_LIKE="lede openwrt"
-PRETTY_NAME="%D %V"
+PRETTY_NAME="%D $VERSION By Zan"
 VERSION_ID="%v"
 HOME_URL="%u"
 BUG_URL="%b"
@@ -15,4 +15,4 @@
 OPENWRT_DEVICE_MANUFACTURER_URL="%m"
 OPENWRT_DEVICE_PRODUCT="%P"
 OPENWRT_DEVICE_REVISION="%h"
-OPENWRT_RELEASE="%D %V %C"
+OPENWRT_RELEASE="%D $VERSION By Zan %C"

--- a/package/base-files/files/bin/config_generate
+++ b/package/base-files/files/bin/config_generate
@@ -162,8 +162,8 @@
 		static)
 			local ipad
 			case "$1" in
-				lan) ipad=${ipaddr:-"192.168.1.1"} ;;
-				*) ipad=${ipaddr:-"192.168.$((addr_offset++)).1"} ;;
+				lan) ipad=${ipaddr:-"10.0.0.1"} ;;
+				*) ipad=${ipaddr:-"10.0.$((addr_offset++)).1"} ;;
 			esac
 
 			netm=${netmask:-"255.255.255.0"}
@@ -177,18 +177,6 @@
 		;;
 
 		dhcp)
-			# fixup IPv6 slave interface if parent is a bridge
-			[ "$type" = "bridge" ] && device="br-$1"
-
-			uci set network.$1.proto='dhcp'
-			[ -e /proc/sys/net/ipv6 ] && {
-				uci -q batch <<-EOF
-					delete network.${1}6
-					set network.${1}6='interface'
-					set network.${1}6.device='$device'
-					set network.${1}6.proto='dhcpv6'
-				EOF
-			}
 		;;
 
 		pppoe)
@@ -197,16 +185,6 @@
 				set network.$1.username='username'
 				set network.$1.password='password'
 			EOF
-			[ -e /proc/sys/net/ipv6 ] && {
-				uci -q batch <<-EOF
-					set network.$1.ipv6='1'
-					delete network.${1}6
-					set network.${1}6='interface'
-					set network.${1}6.device='@${1}'
-					set network.${1}6.proto='dhcpv6'
-				EOF
-			}
-		;;
 	esac
 }
 
@@ -302,8 +280,9 @@
 	uci -q batch <<-EOF
 		delete system.@system[0]
 		add system system
-		set system.@system[-1].hostname='ImmortalWrt'
-		set system.@system[-1].timezone='UTC'
+		set system.@system[-1].hostname='T7'
+		set system.@system[-1].zonename='Asia/Hong Kong'
+		set system.@system[-1].timezone='HKT-8'
 		set system.@system[-1].ttylogin='0'
 		set system.@system[-1].log_size='512'
 		set system.@system[-1].urandom_seed='0'
@@ -311,11 +290,9 @@
 		delete system.ntp
 		set system.ntp='timeserver'
 		set system.ntp.enabled='1'
-		set system.ntp.enable_server='0'
-		add_list system.ntp.server='time1.apple.com'
-		add_list system.ntp.server='time1.google.com'
-		add_list system.ntp.server='time.cloudflare.com'
-		add_list system.ntp.server='pool.ntp.org'
+		set system.ntp.enable_server='1'
+		add_list system.ntp.server='ntp.aliyun.com'
+		add_list system.ntp.server='time2.cloud.tencent.com'
 	EOF
 
 	if json_is_a system object; then
EOF

patch -p1 -E < version.patch && rm -f version.patch
for i in $(find -maxdepth 1 -name 'Patch-*.patch' | sed 's#.*/##');do
	patch -p1 -E < $i
done
rm -f Patch-*.patch
