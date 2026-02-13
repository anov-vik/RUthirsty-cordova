#!/bin/bash
# Cordova Android 构建脚本
# 适用于已安装 Android SDK 的本地环境

set -e

echo "======================================="
echo "  喝水打卡应用 - Android 构建脚本"
echo "======================================="
echo ""

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 错误: 未安装 Node.js"
    echo "请访问 https://nodejs.org 安装 Node.js"
    exit 1
fi
echo "✅ Node.js 版本: $(node -v)"

# 检查 npm
if ! command -v npm &> /dev/null; then
    echo "❌ 错误: 未安装 npm"
    exit 1
fi
echo "✅ npm 版本: $(npm -v)"

# 安装 Cordova CLI（如果未安装）
if ! command -v cordova &> /dev/null; then
    echo "📦 正在安装 Cordova CLI..."
    npm install -g cordova
fi
echo "✅ Cordova 版本: $(cordova -v)"

# 检查 Android SDK
if [ -z "$ANDROID_HOME" ]; then
    echo "❌ 错误: 未设置 ANDROID_HOME 环境变量"
    echo ""
    echo "请设置 ANDROID_HOME 环境变量，例如："
    echo "  export ANDROID_HOME=~/Android/Sdk"
    echo "  或"
    echo "  export ANDROID_HOME=/usr/local/android-sdk"
    exit 1
fi
echo "✅ ANDROID_HOME: $ANDROID_HOME"

# 添加 Android 平台（如果未添加）
if [ ! -d "platforms/android" ]; then
    echo "📱 添加 Android 平台..."
    cordova platform add android
fi

# 检查环境要求
echo ""
echo "🔍 检查 Android 环境要求..."
cordova requirements android

# 构建应用
echo ""
echo "🔨 开始构建 Android 应用..."
BUILD_TYPE=${1:-debug}

if [ "$BUILD_TYPE" == "release" ]; then
    echo "📦 构建发布版本..."
    cordova build android --release
    echo ""
    echo "✅ 构建完成！"
    echo "📍 APK 位置: platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk"
    echo ""
    echo "⚠️  注意: 发布版本需要签名才能安装"
    echo "签名命令:"
    echo "  jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore app-release-unsigned.apk alias_name"
else
    echo "📦 构建调试版本..."
    cordova build android
    echo ""
    echo "✅ 构建完成！"
    echo "📍 APK 位置: platforms/android/app/build/outputs/apk/debug/app-debug.apk"
fi

# 检查连接的设备
echo ""
echo "🔍 检查连接的 Android 设备..."
if command -v adb &> /dev/null; then
    DEVICES=$(adb devices | grep -v "List" | grep "device" | wc -l)
    if [ $DEVICES -gt 0 ]; then
        echo "✅ 发现 $DEVICES 个设备:"
        adb devices -l
        echo ""
        read -p "是否要安装到设备？(y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "📲 正在安装到设备..."
            cordova run android
            echo "✅ 安装完成！"
        fi
    else
        echo "⚠️  未发现连接的设备"
        echo "提示: 使用 USB 连接设备并开启 USB 调试"
    fi
else
    echo "⚠️  adb 命令不可用"
fi

echo ""
echo "======================================="
echo "  构建流程完成！"
echo "======================================="
