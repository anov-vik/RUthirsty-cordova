# Cordova APK 构建工具使用指南

## 🚀 快速开始

### 一键构建 APK

```bash
./cordova-build.sh
```

这将自动执行以下操作：
1. ✅ 检查项目配置
2. ✅ 验证环境依赖
3. ✅ 构建 APK
4. ✅ 显示 APK 位置和大小

## 📋 命令选项

### 构建调试版本（默认）
```bash
./cordova-build.sh
# 或
./cordova-build.sh debug
```
生成位置：`platforms/android/app/build/outputs/apk/debug/app-debug.apk`

### 构建发布版本
```bash
./cordova-build.sh release
```
生成位置：`platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk`

### 清理后重新构建
```bash
./cordova-build.sh clean
```
清理构建缓存，然后重新构建（解决某些构建问题）

### 构建并自动安装
```bash
./cordova-build.sh run
```
构建完成后自动安装到连接的 Android 设备

### 显示帮助
```bash
./cordova-build.sh help
```

## 🎯 功能特性

### 自动化检查
- ✅ 验证是否是 Cordova 项目
- ✅ 检查 Node.js 和 npm
- ✅ 检查 Cordova CLI（未安装会提示安装）
- ✅ 检查 Android 平台（未添加会自动添加）
- ✅ 检查环境依赖（Java、Android SDK、Gradle）

### 智能提示
- 📱 显示应用名称、版本、包名
- ⏱️ 显示构建耗时
- 📊 显示 APK 文件大小
- 💡 提供下一步操作建议

### 彩色输出
- 🟢 成功操作（绿色 ✓）
- 🔴 错误信息（红色 ✗）
- 🟡 警告提示（黄色 ⚠）
- 🔵 信息提示（蓝色 ℹ）

## 📖 详细步骤说明

### 步骤 1: 检查 Cordova 项目
- 查找 `config.xml` 文件
- 读取应用信息（名称、版本、ID）

### 步骤 2: 检查 Node.js 环境
- 验证 Node.js 安装
- 验证 npm 安装
- 显示版本信息

### 步骤 3: 检查 Cordova CLI
- 检查是否安装 Cordova
- 未安装时提供安装选项
- 显示 Cordova 版本

### 步骤 4: 检查 Android 平台
- 检查 `platforms/android` 目录
- 未添加时自动添加平台

### 步骤 5: 检查环境依赖
- 运行 `cordova requirements android`
- 显示依赖检查结果
- 发现问题时提供安装指导

### 步骤 6: 构建 APK
- 显示构建类型（调试/发布）
- 执行构建命令
- 记录构建耗时

### 步骤 7: 显示 APK 信息
- APK 文件路径
- 文件大小
- 下一步操作建议

## 🔧 环境要求

### 必需软件
1. **Node.js** (v14+)
   - 下载：https://nodejs.org

2. **Java JDK** (8 或 11)
   - 下载：https://www.oracle.com/java/technologies/downloads/

3. **Android Studio**
   - 下载：https://developer.android.com/studio
   - 安装组件：
     - Android SDK
     - Android SDK Build-Tools
     - Android SDK Command-line Tools

4. **Gradle**
   - 通常随 Android Studio 自动安装

### 环境变量设置

**Linux/macOS**
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
```

**Windows**
```cmd
setx ANDROID_HOME "%LOCALAPPDATA%\Android\Sdk"
setx PATH "%PATH%;%LOCALAPPDATA%\Android\Sdk\platform-tools"
```

## 🐛 常见问题

### 问题 1: "未找到 config.xml"
**原因**: 不在 Cordova 项目目录中
**解决**:
```bash
cd /workspaces/RUthirsty-cordova
./cordova-build.sh
```

### 问题 2: "未安装 Cordova CLI"
**解决**: 脚本会自动提示安装，或手动安装：
```bash
npm install -g cordova
```

### 问题 3: "环境检查失败"
**原因**: 缺少 Java、Android SDK 或 Gradle
**解决**:
1. 安装 Android Studio
2. 设置 ANDROID_HOME 环境变量
3. 运行 `cordova requirements android` 查看详情

### 问题 4: "构建失败"
**解决**:
```bash
# 尝试清理后重新构建
./cordova-build.sh clean

# 或手动清理
cd platforms/android
./gradlew clean
cd ../..
./cordova-build.sh
```

### 问题 5: "Gradle 下载慢"
**解决**: 配置 Gradle 镜像
```bash
# 编辑 ~/.gradle/init.gradle
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/public/' }
        maven { url 'https://maven.aliyun.com/repository/google/' }
    }
}
```

## 📦 APK 签名（发布版本）

### 1. 生成密钥库
```bash
keytool -genkey -v -keystore my-release-key.keystore \
  -alias my-app-alias \
  -keyalg RSA -keysize 2048 -validity 10000
```

### 2. 签名 APK
```bash
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
  -keystore my-release-key.keystore \
  platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  my-app-alias
```

### 3. 对齐 APK
```bash
zipalign -v 4 \
  platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  RUthirsty-release.apk
```

## 📱 安装到设备

### 使用 Cordova
```bash
cordova run android
```

### 使用 ADB
```bash
adb install -r platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

### 手动安装
1. 将 APK 文件传输到手机
2. 在手机上打开文件管理器
3. 点击 APK 文件安装
4. 允许安装未知来源应用（系统设置）

## 🧪 测试 APK

### 在模拟器中测试
```bash
# 启动模拟器
emulator -avd Pixel_4_API_30

# 安装 APK
cordova emulate android
```

### 在真机上测试
1. 开启 USB 调试
2. 连接设备
3. 运行：
```bash
./cordova-build.sh run
```

## 💡 高级用法

### 自定义构建配置

编辑 `platforms/android/app/build.gradle`：
```gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 多版本构建
```bash
# 构建调试版本
./cordova-build.sh debug

# 构建发布版本
./cordova-build.sh release

# 比较文件大小
ls -lh platforms/android/app/build/outputs/apk/*/app-*.apk
```

## 📊 输出示例

```
╔════════════════════════════════════════════════════════╗
║  🚀 Cordova APK Builder - 自动化构建工具              ║
╚════════════════════════════════════════════════════════╝

▶ 步骤 1/7: 检查 Cordova 项目
✓ 找到 Cordova 项目配置
ℹ 应用名称: 喝水打卡
ℹ 应用版本: 1.1.0
ℹ 应用 ID:  com.ruthirsty.app

▶ 步骤 2/7: 检查 Node.js 环境
✓ Node.js 版本: v18.12.1
✓ npm 版本: 9.2.0

[... 更多步骤 ...]

╔════════════════════════════════════════════════════════╗
║  🚀 构建完成！                                        ║
╠════════════════════════════════════════════════════════╣
║  📦 APK 位置:                                         ║
║     platforms/android/app/build/outputs/apk/debug/app-debug.apk
║                                                         ║
║  📊 文件大小: 3.2M                                     ║
║                                                         ║
╚════════════════════════════════════════════════════════╝
```

## 🎯 最佳实践

1. **首次构建**: 使用 `./cordova-build.sh` 检查所有依赖
2. **日常开发**: 使用 `./cordova-build.sh run` 快速测试
3. **发布前**: 使用 `./cordova-build.sh release` 并签名
4. **遇到问题**: 使用 `./cordova-build.sh clean` 清理重建

## 🔗 相关资源

- Cordova 官方文档: https://cordova.apache.org/docs/
- Android 开发者指南: https://developer.android.com/
- APK 签名指南: https://developer.android.com/studio/publish/app-signing

---

**祝你构建顺利！** 🎉
