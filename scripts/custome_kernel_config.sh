#!/bin/bash

source .current_config.mk

KCFG="kernel/arch/arm64/configs/$(awk '{print $1}' <<< "$TARGET_KERNEL_CONFIG")"

if [ ! -f "$KCFG" ]; then
    echo "Kernel config not found: $KCFG"
    exit 1
fi

# 保留原脚本的网络功能配置
bash kernel/scripts/config --file "$KCFG" \
    --module NET_ACT_CT \
    --module NET_ACT_CTINFO

# 开启 BPF 和内核 BTF
bash kernel/scripts/config --file "$KCFG" \
    --enable BPF \
    --enable BPF_SYSCALL \
    --enable BPF_JIT \
    --enable DEBUG_INFO \
    --disable DEBUG_INFO_NONE \
    --disable DEBUG_INFO_REDUCED \
    --disable DEBUG_INFO_SPLIT \
    --disable DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT \
    --disable DEBUG_INFO_DWARF5 \
    --enable DEBUG_INFO_DWARF4 \
    --enable DEBUG_INFO_BTF

echo "Updated kernel config: $KCFG"
grep -E 'CONFIG_(BPF|BPF_SYSCALL|BPF_JIT|DEBUG_INFO.*)[= ]' "$KCFG"
