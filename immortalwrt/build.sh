#!/bin/bash
# shellcheck disable=SC2207

: "${MIRROR_URL:="https://mirror.nju.edu.cn/immortalwrt"}"

if [ -n "$MIRROR_URL" ]; then
    # 替换软件源
    if [ -f repositories.conf ]; then
        sed -i "s|https://downloads.immortalwrt.org|$MIRROR_URL|g" repositories.conf
    elif [ -f repositories ]; then
        sed -i "s|https://downloads.immortalwrt.org|$MIRROR_URL|g" repositories
    fi
fi

# 不需要的格式
cat <<EOF >>.config
CONFIG_ISO_IMAGES=n
CONFIG_VDI_IMAGES=n
CONFIG_VMDK_IMAGES=n
CONFIG_VHDX_IMAGES=n
CONFIG_QCOW2_IMAGES=n
CONFIG_TARGET_ROOTFS_SQUASHFS=n
EOF

# 修改默认对齐大小
# 1. 对 UEFI 更友好
# 2. 修复警告 "bios boot partition is under 1 MiB"
# * 原本 256 对齐的系统，不可直接用 sysupgrade 升级 1024 对齐的固件，会损坏原有分区表
sed -i 's/256/1024/g' target/linux/x86/image/Makefile

# 包含组件
INCLUDEDS=(
    # kmod：PVE 虚拟网卡驱动
    kmod-8139cp  # Realtek 8139C+ PCI 网卡驱动
    kmod-8139too # Realtek 8139 PCI 网卡驱动
    kmod-e1000   # Intel PRO/1000 PCI 网卡驱动
    kmod-e1000e  # Intel PRO/1000 PCI-E 网卡驱动
    kmod-vmxnet3 # VMware VMXNET3 虚拟网卡驱动

    # kmod：直通网卡驱动
    kmod-igc # Intel I225/I226 2.5GbE 网卡驱动

    # kmod：网络设备
    kmod-bonding # Bonding 网络设备支持

    # 其他驱动
    kmod-mmc # MMC/SD 存储设备驱动

    # 完整工具
    -dnsmasq dnsmasq-full
    -ip-tiny ip-full
    -ethtool ethtool-full
    -nano nano-full

    # 其他工具
    usbutils
    htop
    curl
    # wget-ssl tar gzip xz bzip2

    # luci
    luci
    luci-light
    luci-compat
    luci-lib-ipkg

    # luci 主题
    luci-theme-argon

    # luci 应用
    luci-i18n-base-zh-cn            # 基础中文包
    luci-i18n-firewall-zh-cn        # 防火墙
    luci-i18n-package-manager-zh-cn # 软件包管理工具
    luci-i18n-upnp-zh-cn            # UPnP 管理工具
    luci-i18n-argon-config-zh-cn    # Argon 配置工具
)

# 排除组件
EXCLUDEDS=(
    # 显卡驱动
    kmod-drm-i915     # Intel i915 系列显卡驱动
    i915-firmware-dmc # Intel i915 系列显卡驱动依赖
    kmod-drm-amdgpu   # AMD 系列显卡驱动

    # 有线网络驱动
    kmod-8139cp      # Realtek 8139C+ PCI 网卡驱动
    kmod-8139too     # Realtek 8139 PCI 网卡驱动
    kmod-r8101       # Realtek RTL8101 PCI 网卡驱动
    kmod-r8125       # Realtek RTL8125 PCI 2.5GbE 网卡驱动
    kmod-r8126       # Realtek RTL8126 PCI 5GbE 网卡驱动
    kmod-r8168       # Realtek RTL8168 PCI 1GbE 网卡驱动
    kmod-e1000       # Intel PRO/1000 PCI 网卡驱动
    kmod-e1000e      # Intel PRO/1000 PCI-E 网卡驱动
    kmod-i40e        # Intel XL710 40GbE 网卡驱动
    kmod-iavf        # Intel XL710 10GbE 虚拟功能 (VF) 驱动
    kmod-igb         # Intel 82575/82576 PCI-Express 1GbE 网卡驱动
    kmod-igbvf       # Intel 82576 1Gb 虚拟功能 (VF) 驱动
    kmod-ixgbe       # Intel 82598/82599 PCI-Express 10GbE 网卡驱动
    kmod-ixgbevf     # Intel 82599 10GbE 虚拟功能 (VF) 驱动
    kmod-igc         # Intel I225/I226 2.5GbE 网卡驱动
    kmod-dwmac-intel # Intel GMAC 支持
    kmod-pcnet32     # AMD PCNet32 网卡驱动
    kmod-amd-xgbe    # AMD 10GbE 网卡驱动
    kmod-atlantic    # Aquantia AQtion 10GbE 网卡驱动
    kmod-bnx2        # Broadcom NetXtreme II 网卡驱动 (BCM5706/5708/5709/5716)
    kmod-bnx2x       # Broadcom NetXtreme II X 网卡驱动 (BCM57710/57711/57711E/57712/57712_MF/57800/57800_MF/57810/57810_MF/57840/57840_MF)
    kmod-tg3         # Broadcom Tigon3 1GbE 网卡驱动
    kmod-mlx4-core   # Mellanox MLX4 网卡驱动
    kmod-mlx5-core   # Mellanox MLX5 网卡驱动
    kmod-forcedeth   # NVIDIA 网卡驱动
    kmod-amazon-ena  # Amazon EC2 ENA (Elastic Network Adapter)
    kmod-tulip       # Tulip 系列网卡驱动
    kmod-vmxnet3     # VMware VMXNET3 虚拟网卡驱动

    # USB 相关网络驱动
    kmod-usb-net                # USB 以太网设备基础驱动
    kmod-usb-net-aqc111         # Aquantia AQtion 5/2.5GbE
    kmod-usb-net-asix           # Asix convertors
    kmod-usb-net-asix-ax88179   # ASIX AX88179 based USB 3.0/2.0…
    kmod-usb-net-kaweth         # Kaweth convertors
    kmod-usb-net-lan78xx        # Microchip LAN78XX based USB 2 & USB 3…
    kmod-usb-net-mcs7830        # MCS7830 convertors
    kmod-usb-net-pegasus        # Pegasus convertors
    kmod-usb-net-rtl8150        # Realtek 8150 convertors
    kmod-usb-net-rtl8152-vendor # Realtek RTL8152 USB Ethernet chipsets
    kmod-usb-net-smsc75xx       # SMSC LAN75XX based devices
    kmod-usb-net-smsc95xx       # SMSC LAN95XX based devices
    kmod-usb-net-sr9700         # CoreChip-sz SR9700 based USB 1.1 10/100 ethernet devices
)

# 将明确包含的组件从排除列表中移除
EXCLUDEDS=($(printf "%s\n" "${EXCLUDEDS[@]}" | grep -Fxv -f <(printf "%s\n" "${INCLUDEDS[@]}")))

PACKAGES="$(printf '%s ' "${INCLUDEDS[@]}") $(printf -- '-%s ' "${EXCLUDEDS[@]}")"

make image PACKAGES="$PACKAGES" ROOTFS_PARTSIZE="512" -j"$(nproc)"
