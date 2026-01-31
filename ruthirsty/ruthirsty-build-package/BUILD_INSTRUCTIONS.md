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
