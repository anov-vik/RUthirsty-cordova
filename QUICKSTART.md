# 🚀 快速开始指南

## 当前状态

✅ **Cordova 项目已完全配置完成**
✅ **Web 应用已在 Codespaces 运行** (端口 8080)
✅ **Android 平台已添加**
⚠️  **需要本地环境构建 APK**

---

## 🌐 方案 A: 立即测试（推荐）

**在浏览器中预览应用 - 无需任何安装！**

1. 在 GitHub Codespaces，点击顶部的 "端口" 标签
2. 找到端口 8080，点击地球图标 🌐
3. 应用将在新标签页中打开

你可以立即测试所有功能：
- 打卡喝水
- 查看统计
- 记录列表
- 数据持久化

---

## 📱 方案 B: 构建 Android APK

由于 Codespaces 环境限制，需要在本地机器上构建。

### 步骤 1: 下载项目到本地

```bash
# 克隆仓库
git clone <your-repo-url>
cd RUthirsty-cordova
```

### 步骤 2: 设置 Android 环境

详细步骤请查看: **`ANDROID_BUILD_GUIDE.md`**

简要说明:
1. 安装 Node.js
2. 安装 Java JDK
3. 安装 Android Studio 和 SDK
4. 设置 ANDROID_HOME 环境变量

### 步骤 3: 构建 APK

**使用自动化脚本（最简单）:**

```bash
chmod +x build-android.sh
./build-android.sh
```

**手动构建:**

```bash
npm install -g cordova
cordova requirements android  # 检查环境
cordova build android         # 构建 APK
```

APK 位置: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`

### 步骤 4: 安装到手机

```bash
# 方法 1: 使用 Cordova
cordova run android

# 方法 2: 手动安装
# 将 app-debug.apk 传输到手机并安装
```

---

## 📝 项目文件说明

| 文件 | 说明 |
|------|------|
| `www/` | Web 应用源代码（HTML/CSS/JS） |
| `config.xml` | Cordova 配置文件 |
| `build-android.sh` | Android 构建脚本 |
| `ANDROID_BUILD_GUIDE.md` | 详细的 Android 构建指南 |
| `README_APP.md` | 应用功能文档 |

---

## 💡 开发建议

### 在 Codespaces 中开发
- 修改 `www/` 目录下的文件
- Live Server 自动刷新预览
- 快速迭代和测试

### 在本地构建
- 下载最新代码
- 运行 `./build-android.sh`
- 安装到真机测试

---

## 🆘 需要帮助？

- 📖 查看 `ANDROID_BUILD_GUIDE.md` 获取详细构建步骤
- 📖 查看 `README_APP.md` 了解应用功能
- 🐛 遇到问题？检查常见问题部分

---

**现在就在浏览器中试试吧！** 🎉
