#!/bin/bash

# 使用 Capacitor 或直接导出项目用于其他构建工具

echo "📦 准备项目文件用于外部构建..."
echo ""

# 创建构建包
cd /workspaces/RUthirsty-cordova/ruthirsty
OUTPUT_DIR="ruthirsty-build-package"

# 清理旧的构建包
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# 复制必要文件
echo "复制项目文件..."
cp -r www "$OUTPUT_DIR/"
cp config.xml "$OUTPUT_DIR/"
cp package.json "$OUTPUT_DIR/"

# 创建说明文件
cat > "$OUTPUT_DIR/BUILD_INSTRUCTIONS.md" << 'EOF'
# 喝水打卡 APK 构建说明

## 选项1: 本地构建

### 前置要求
1. 安装 Android Studio: https://developer.android.com/studio
2. 安装 Node.js 和 Cordova: npm install -g cordova
3. 配置环境变量:
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
   ```

### 构建步骤
```bash
# 1. 创建 Cordova 项目
cordova create ruthirsty com.ruthirsty.app 喝水打卡

# 2. 复制 www 和 config.xml 到项目目录
cp -r www ruthirsty/
cp config.xml ruthirsty/

# 3. 添加 Android 平台
cd ruthirsty
cordova platform add android

# 4. 构建 APK
cordova build android

# APK 位置: platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

## 选项2: 使用 GitHub Actions 自动构建

创建 .github/workflows/build-apk.yml:

```yaml
name: Build Android APK
on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'temurin'
          java-version: '11'

      - name: Setup Android SDK
        uses: android-actions/setup-android@v2

      - name: Install Cordova
        run: npm install -g cordova

      - name: Add Android platform
        run: cordova platform add android

      - name: Build APK
        run: cordova build android

      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-debug
          path: platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

## 选项3: 使用 Expo EAS (如果迁移到 React Native)

## 选项4: 使用 Cordova CLI 云构建服务

访问: https://build.phonegap.com/ (PhoneGap Build)
或其他类似服务
EOF

echo "✅ 构建包已创建: $OUTPUT_DIR/"
echo ""
echo "📍 位置: $(pwd)/$OUTPUT_DIR"
echo ""
echo "你可以："
echo "1. 下载整个项目到本地机器构建"
echo "2. 使用 GitHub Actions 自动构建"
echo "3. 查看 BUILD_INSTRUCTIONS.md 获取详细说明"
