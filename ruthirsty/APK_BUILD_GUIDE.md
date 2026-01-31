# 🚀 喝水打卡 APK 构建完整指南

## 当前状态

✅ 应用代码完成
✅ Cordova 项目配置完成
✅ 构建 Skill 已创建
⚠️  需要 Android SDK 环境来构建

## 🎯 三种构建方案

### 方案1: GitHub Actions 自动构建 ⭐⭐⭐（最推荐）

**优点**: 无需本地环境，自动化构建，每次提交自动生成 APK

**步骤**:

1. **推送代码到 GitHub**
   ```bash
   cd /workspaces/RUthirsty-cordova
   git add .
   git commit -m "Add Cordova water check-in app"
   git push origin main
   ```

2. **触发构建**
   - 访问 GitHub 仓库页面
   - 点击 "Actions" 标签
   - 选择 "Build Android APK" 工作流
   - 点击 "Run workflow"

3. **下载 APK**
   - 等待构建完成（约 5-10 分钟）
   - 在 Artifacts 中下载 `ruthirsty-debug-apk`
   - 解压得到 `app-debug.apk`

4. **安装到手机**
   - 将 APK 传输到手机
   - 允许安装未知来源应用
   - 点击 APK 安装

---

### 方案2: 本地机器构建 ⭐⭐

**优点**: 完全控制，可快速迭代

**前置要求**:

1. **安装 Android Studio**
   - 下载: https://developer.android.com/studio
   - 运行并完成初始设置

2. **配置 SDK**
   - Tools → SDK Manager
   - 安装: Android SDK Platform 33+, Build Tools 33.0.0+
   - 接受所有许可

3. **设置环境变量**

   **Linux/Mac** (添加到 ~/.bashrc 或 ~/.zshrc):
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

   # 重新加载
   source ~/.bashrc
   ```

   **Windows**:
   - 系统属性 → 高级 → 环境变量
   - 新建: `ANDROID_HOME` = `C:\Users\你的用户名\AppData\Local\Android\Sdk`
   - 编辑 Path: 添加 `%ANDROID_HOME%\tools` 和 `%ANDROID_HOME%\platform-tools`

**构建步骤**:

```bash
# 1. 克隆或下载项目到本地
cd /path/to/ruthirsty

# 2. 检查环境
./cordova-apk-builder/scripts/check_environment.sh

# 3. 如果需要，运行配置脚本
./cordova-apk-builder/scripts/setup_environment.sh

# 4. 构建 Debug APK
./cordova-apk-builder/scripts/build_apk.sh

# 5. 构建 Release APK
./cordova-apk-builder/scripts/build_apk.sh --release

# 6. 构建并安装到连接的设备
./cordova-apk-builder/scripts/build_apk.sh --install
```

**APK 位置**:
- Debug: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`
- Release: `platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk`

---

### 方案3: 使用在线构建服务 ⭐

**选项 A: Ionic Appflow**
- 访问: https://ionic.io/appflow
- 上传项目
- 配置构建

**选项 B: Apache Cordova Build (已停止维护)**
- 可寻找替代服务

---

## 📱 APK 安装到手机

### 方法1: 直接安装

1. 将 APK 文件传输到手机
2. 在手机上找到 APK 文件
3. 点击安装
4. 允许"安装未知应用"权限

### 方法2: ADB 安装

```bash
# 连接手机到电脑 (开启USB调试)
adb devices

# 安装 APK
adb install -r app-debug.apk

# 或使用 Cordova
cordova run android
```

---

## 🔧 故障排除

### 问题1: ANDROID_HOME 未设置

**解决**: 运行 `cordova-apk-builder/scripts/setup_environment.sh`

### 问题2: Java 版本不兼容

**解决**: 安装 JDK 11 或更高版本
```bash
# Ubuntu/Debian
sudo apt-get install openjdk-11-jdk

# Mac
brew install openjdk@11
```

### 问题3: Gradle 构建失败

**解决**: 清理并重建
```bash
cordova clean
rm -rf platforms/android/app/build
cordova build android
```

### 问题4: 网络问题

**解决**: 配置 Gradle 使用镜像

编辑 `platforms/android/build.gradle`:
```gradle
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/google/' }
        maven { url 'https://maven.aliyun.com/repository/public/' }
        google()
        mavenCentral()
    }
}
```

**完整故障排除**: 查看 `cordova-apk-builder/references/troubleshooting.md`

---

## 📊 构建输出信息

成功构建后会显示:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Build successful!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 APK Location:
   /path/to/platforms/android/app/build/outputs/apk/debug/app-debug.apk

📊 APK Size: 3.2M

💡 To install, run:
   adb install -r app-debug.apk
   or: cordova run android
```

---

## 🎓 学习资源

- **Cordova 官方文档**: https://cordova.apache.org/docs/
- **Android 开发文档**: https://developer.android.com/
- **Skill 故障排除指南**: `cordova-apk-builder/references/troubleshooting.md`

---

## ✅ 快速检查清单

构建前检查:

- [ ] Node.js 已安装 (v14+)
- [ ] Cordova CLI 已安装
- [ ] Java JDK 已安装 (11+)
- [ ] Android SDK 已安装
- [ ] ANDROID_HOME 环境变量已设置
- [ ] 运行 `check_environment.sh` 全部通过

---

## 💡 推荐工作流

1. **开发阶段**: 使用浏览器测试 (`standalone.html`)
2. **测试阶段**: 使用 GitHub Actions 构建 Debug APK
3. **发布阶段**: 本地构建 Release APK 并签名

---

## 📞 获取帮助

- 查看 `cordova-apk-builder/` skill 文档
- 运行 `./cordova-apk-builder/scripts/check_environment.sh`
- 查看详细日志: `cordova build android --verbose`

**祝你构建成功！** 🎉
