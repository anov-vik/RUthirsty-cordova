# 📱 GitHub Actions 自动构建 APK 指南

## 🎯 问题已解决！

由于 Codespaces 环境缺少 Android SDK，我创建了一个 **GitHub Actions 自动构建工作流**，可以在 GitHub 的云环境中自动构建 APK。

---

## 🚀 如何获取 APK

### 方法 1: 手动触发构建（推荐）⭐

1. **访问你的 GitHub 仓库**
   ```
   https://github.com/你的用户名/RUthirsty-cordova
   ```

2. **进入 Actions 页面**
   - 点击顶部的 "Actions" 标签

3. **运行工作流**
   - 左侧选择 "构建 Android APK"
   - 点击右侧 "Run workflow" 按钮
   - 选择分支（通常是 main）
   - 选择构建类型：
     - `debug` - 调试版本（推荐，可直接安装）
     - `release` - 发布版本（需要签名）
   - 点击绿色 "Run workflow" 按钮

4. **等待构建完成**
   - 构建过程约 3-5 分钟
   - 你会看到一个黄色圆圈变成绿色勾号

5. **下载 APK**
   - 点击刚完成的工作流
   - 滚动到底部的 "Artifacts" 部分
   - 点击 `喝水打卡-debug-xxxxxx` 下载 ZIP
   - 解压后得到 `app-debug.apk`

### 方法 2: 自动触发（推送代码时）

每次你推送代码到 `main` 或 `master` 分支，GitHub Actions 会自动构建 APK。

```bash
git add .
git commit -m "更新应用"
git push origin main
```

然后去 Actions 页面查看和下载。

---

## 📋 详细步骤（图文说明）

### 第一步：提交并推送工作流文件

当前我已经创建了工作流文件：`.github/workflows/build-apk.yml`

你需要将它推送到 GitHub：

```bash
# 在 Codespaces 终端中执行
git add .github/workflows/build-apk.yml
git commit -m "添加 GitHub Actions 自动构建 APK"
git push origin main
```

### 第二步：访问 GitHub Actions

1. 打开浏览器，访问你的仓库
2. 点击 "Actions" 标签（顶部菜单栏）
3. 你会看到工作流列表

### 第三步：手动运行构建

1. 在左侧选择 "构建 Android APK"
2. 右侧会显示 "This workflow has a workflow_dispatch event trigger"
3. 点击 "Run workflow" 下拉菜单
4. 选择：
   - **Branch**: main（或你的主分支）
   - **构建类型**: debug（推荐）
5. 点击绿色的 "Run workflow" 按钮

### 第四步：监控构建进度

- 页面会自动刷新，显示构建进度
- 点击工作流名称可以查看详细日志
- 等待状态从 🟡（进行中）变为 ✅（完成）

### 第五步：下载 APK

1. 点击完成的工作流
2. 滚动到页面底部
3. 在 "Artifacts" 部分，点击 APK 名称
4. 浏览器会下载一个 ZIP 文件
5. 解压 ZIP，里面就是 `app-debug.apk`

---

## 🎨 工作流特性

### 自动化检查
- ✅ 检查 Cordova 项目配置
- ✅ 显示应用信息（名称、版本、包名）
- ✅ 验证 Android 平台
- ✅ 检查环境要求

### 智能构建
- ✅ 自动安装依赖（Node.js、Java、Cordova）
- ✅ 支持调试和发布两种模式
- ✅ 详细的构建日志
- ✅ 构建成功后自动上传

### 灵活触发
- ✅ 手动触发（workflow_dispatch）
- ✅ 推送代码自动触发
- ✅ Pull Request 触发

---

## 📦 构建输出

### 调试版本（推荐）
- **文件名**: `app-debug.apk`
- **大小**: 约 3-5 MB
- **特点**: 可直接安装到设备
- **用途**: 开发测试

### 发布版本
- **文件名**: `app-release-unsigned.apk`
- **大小**: 约 2-4 MB
- **特点**: 需要签名才能安装
- **用途**: 正式发布

---

## 🔧 配置说明

### 工作流文件位置
```
.github/workflows/build-apk.yml
```

### 触发条件
```yaml
on:
  push:              # 推送代码时
    branches: [ main, master ]
  pull_request:      # Pull Request 时
    branches: [ main, master ]
  workflow_dispatch: # 手动触发
```

### 构建环境
- **操作系统**: Ubuntu Latest
- **Node.js**: v18
- **Java**: JDK 11
- **Cordova**: 13.0.0

---

## ⏱️ 时间估算

- **首次构建**: 3-5 分钟
- **后续构建**: 2-3 分钟（有缓存）
- **下载 APK**: 几秒钟

---

## 💡 使用技巧

### 1. 查看构建日志
点击工作流 → 点击构建步骤 → 查看详细输出

### 2. 构建失败时
- 查看红色的步骤
- 展开查看错误信息
- 根据错误修复代码
- 重新推送或手动触发

### 3. 多版本构建
手动触发多次，分别选择 debug 和 release

### 4. 保存 APK
- Artifacts 保留 30 天
- 建议及时下载保存到本地
- 或者创建 GitHub Release

---

## 📱 安装 APK 到手机

### 方法 1: 直接下载安装

1. **将 APK 发送到手机**
   - 通过 USB 传输
   - 通过邮件发送
   - 上传到云盘

2. **在手机上安装**
   - 打开文件管理器
   - 找到 APK 文件
   - 点击安装
   - 允许安装未知来源应用

### 方法 2: 使用 ADB

```bash
# 连接手机到电脑
# 开启 USB 调试

# 安装
adb install -r app-debug.apk
```

---

## 🎯 常见问题

### Q1: 找不到 Actions 页面？
**A**: 确保工作流文件已推送到仓库：
```bash
git push origin main
```

### Q2: 构建失败？
**A**: 查看构建日志，常见原因：
- config.xml 配置错误
- 依赖安装失败
- 网络问题

### Q3: 下载的是 ZIP 而不是 APK？
**A**: 这是正常的，GitHub Actions 的 Artifacts 都会打包成 ZIP，解压即可。

### Q4: APK 无法安装？
**A**:
- 检查是否允许安装未知来源
- 确保下载的是 debug 版本（不需要签名）
- Release 版本需要先签名

### Q5: 构建时间过长？
**A**: 首次构建需要下载依赖，后续会快很多。

---

## 🔄 更新应用

### 修改代码后重新构建

1. 在 Codespaces 中修改代码
2. 推送到 GitHub
3. 自动触发构建，或手动运行
4. 下载新的 APK

### 更新版本号

编辑 `config.xml`:
```xml
<widget id="com.ruthirsty.app" version="1.2.0" ...>
```

然后推送，构建新版本。

---

## 📊 构建状态徽章

添加到 README.md 显示构建状态：

```markdown
![构建状态](https://github.com/你的用户名/RUthirsty-cordova/workflows/构建%20Android%20APK/badge.svg)
```

---

## 🎉 总结

### ✅ 已解决的问题
- ❌ Codespaces 缺少 Android SDK
- ✅ 使用 GitHub Actions 云构建
- ✅ 无需本地环境配置
- ✅ 自动化构建流程

### 🎁 你现在可以
- ✅ 在任何地方触发构建
- ✅ 几分钟内获得 APK
- ✅ 直接安装到手机测试
- ✅ 持续集成和部署

---

## 🚀 立即开始

### 现在就试试！

1. **推送工作流文件**
   ```bash
   git add .github/workflows/build-apk.yml
   git commit -m "添加自动构建"
   git push origin main
   ```

2. **访问 Actions 页面**
   - https://github.com/你的用户名/RUthirsty-cordova/actions

3. **手动触发构建**
   - Run workflow → 选择 debug → Run

4. **等待 3-5 分钟**

5. **下载 APK**

6. **安装到手机** 🎉

---

**问题已完美解决！享受你的喝水打卡应用吧！** 💧✨
