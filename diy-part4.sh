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
--- a/feeds/luci/modules/luci-base/root/etc/config/luci
+++ b/feeds/luci/modules/luci-base/root/etc/config/luci
@@ -1,6 +1,6 @@
 config core main
 	option lang auto
-	option mediaurlbase /luci-static/bootstrap
+	option mediaurlbase /luci-static/design
 	option resourcebase /luci-static/resources
 	option ubuspath /ubus/
 	

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
EOF

patch -p1 -E < version.patch && rm -f version.patch
for i in $(find -maxdepth 1 -name 'Patch-*.patch' | sed 's#.*/##');do
	patch -p1 -E < $i
done
rm -f Patch-*.patch

sed -i "s/192.168.6.1/10.0.0.2/g" package/base-files/files/bin/config_generate
sed -i "s/hostname='ImmortalWrt'/hostname='T7'/g" package/base-files/files/bin/config_generate
sed -i "s/timezone='UTC'/timezone='HKT-8'/g" package/base-files/files/bin/config_generate
sed -i "s/add_list system.ntp.server='time1.apple.com'/add_list system.ntp.server='ntp.aliyun.com'/g" package/base-files/files/bin/config_generate
sed -i "s/add_list system.ntp.server='time1.google.com'/add_list system.ntp.server='time2.cloud.tencent.com'/g" package/base-files/files/bin/config_generate
