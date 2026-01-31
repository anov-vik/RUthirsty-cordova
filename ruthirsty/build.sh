#!/bin/bash

echo "======================================"
echo "喝水打卡应用 - 构建脚本"
echo "======================================"
echo ""

# 检查 Cordova 是否安装
if ! command -v cordova &> /dev/null; then
    echo "❌ Cordova 未安装"
    echo "请运行: npm install -g cordova"
    exit 1
fi

echo "✓ Cordova 已安装: $(cordova -v)"

# 检查环境
echo ""
echo "检查构建环境..."
cordova requirements android

echo ""
echo "选择构建类型:"
echo "1) 调试版本 (Debug APK)"
echo "2) 发布版本 (Release APK)"
echo "3) 在设备上运行"
echo "4) 在浏览器中测试"
read -p "请选择 (1-4): " choice

case $choice in
    1)
        echo ""
        echo "正在构建调试版本..."
        cordova build android
        echo ""
        echo "✓ 构建完成!"
        echo "APK 位置: platforms/android/app/build/outputs/apk/debug/app-debug.apk"
        ;;
    2)
        echo ""
        echo "正在构建发布版本..."
        cordova build android --release
        echo ""
        echo "✓ 构建完成!"
        echo "APK 位置: platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk"
        echo ""
        echo "注意: 发布版本需要签名才能安装"
        ;;
    3)
        echo ""
        echo "正在运行应用..."
        echo "请确保 Android 设备已连接并启用 USB 调试"
        cordova run android
        ;;
    4)
        echo ""
        echo "启动开发服务器..."
        echo "在浏览器中访问: http://localhost:8000"
        cordova serve
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac
