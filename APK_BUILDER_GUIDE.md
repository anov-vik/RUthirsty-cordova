# APK Builder - 智能构建助手

## 🎯 这是什么？

**APK Builder** 是一个智能交互式工具，可以自动检测你的环境并选择最佳的 APK 构建方案。类似于一个 "skill"，但更智能！

## ✨ 功能特点

### 🔍 智能环境检测
- ✅ 自动检测 Cordova 项目
- ✅ 检查 Android SDK 配置
- ✅ 检测 Git 仓库设置
- ✅ 验证 GitHub Actions 配置

### 🎯 自动方案选择
根据环境自动推荐最佳构建方案：

**场景 1: 本地有 Android SDK**
- 推荐直接本地构建
- 提供调试/发布版本选项
- 自动调用 cordova-build.sh

**场景 2: 配置了 GitHub Actions**
- 推荐使用云构建
- 自动推送代码
- 提供 Actions 页面链接

**场景 3: 无构建环境**
- 显示所有可用方案
- 提供详细配置指南
- 链接到相关文档

### 💡 交互式界面
- 🎨 彩色输出，清晰易读
- 📋 菜单式选择
- 💬 智能提示和建议
- 📖 自动打开相关文档

## 🚀 使用方法

### 一键启动

```bash
./apk-builder
```

### 使用流程

1. **运行脚本**
   ```bash
   ./apk-builder
   ```

2. **自动检测环境**
   - 脚本会自动检测当前环境
   - 显示检测结果

3. **选择操作**
   - 根据提示选择构建方案
   - 输入数字选择菜单项

4. **自动执行**
   - 脚本会自动执行选择的操作
   - 提供详细的进度信息

## 📋 示例场景

### 场景 1: 本地环境构建

```bash
$ ./apk-builder

╔═══════════════════════════════════════════════════════════╗
║  📱 Cordova APK 构建助手                                  ║
║  智能选择最佳构建方案                                     ║
╚═══════════════════════════════════════════════════════════╝

🔍 正在检测构建环境...

✓ Cordova 项目检测成功
  应用名称: 喝水打卡
  版本号: 1.1.0
  包名: com.ruthirsty.app

✓ Cordova CLI: 13.0.0
✓ Android SDK 已配置
✓ Git 仓库: https://github.com/xxx/RUthirsty-cordova

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 推荐方案: 本地构建 (最快)

检测到 Android SDK，可以直接构建 APK。

是否立即开始构建？
  [1] 是，构建调试版本 (推荐)
  [2] 是，构建发布版本
  [3] 否，查看其他方案
  [4] 退出

请选择 [1-4]: 1

🔨 开始构建调试版本...
[构建过程...]
✓ APK 构建成功！
```

### 场景 2: GitHub Actions 云构建

```bash
$ ./apk-builder

[环境检测...]

✓ Cordova 项目检测成功
⚠ Android SDK 未配置
✓ Git 仓库已配置

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 推荐方案: GitHub Actions 云构建

检测到 GitHub Actions 配置，可以使用云构建。
优势: 无需本地 Android SDK，3-5 分钟获得 APK

⚠ 本地未配置 Android SDK，推荐使用此方案

选择操作：
  [1] 推送代码并自动触发构建
  [2] 仅推送代码（稍后手动触发）
  [3] 打开 GitHub Actions 页面
  [4] 查看构建说明
  [5] 退出

请选择 [1-5]: 1

📤 正在推送代码...
✓ 代码已推送！

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 GitHub Actions 正在构建 APK！
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⏱️  预计时间: 3-5 分钟

📥 查看构建进度:
   https://github.com/xxx/RUthirsty-cordova/actions

💡 下载 APK:
   1. 访问上面的链接
   2. 点击最新的工作流
   3. 等待完成（绿色 ✓）
   4. 滚动到底部 Artifacts
   5. 点击下载 ZIP
   6. 解压得到 APK
```

### 场景 3: 无构建环境

```bash
$ ./apk-builder

[环境检测...]

✓ Cordova 项目检测成功
⚠ Cordova CLI 未安装
⚠ Android SDK 未配置
⚠ 未配置 Git 仓库

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠ 未检测到可用的构建环境

可用方案:

方案 1: 配置本地环境
  - 安装 Android Studio
  - 配置 ANDROID_HOME
  - 运行 ./cordova-build.sh
  📖 详见: ANDROID_BUILD_GUIDE.md

方案 2: 使用 GitHub Actions
  - 设置 GitHub Actions 工作流
  - 推送代码自动构建
  - 在线下载 APK
  📖 详见: GITHUB_ACTIONS_GUIDE.md

方案 3: 下载项目到本地
  - 在有 Android SDK 的机器上构建
  - 使用自动化脚本
  📖 详见: HOW_TO_BUILD_APK.md

选择操作：
  [1] 查看本地环境配置指南
  [2] 查看 GitHub Actions 配置
  [3] 查看所有构建方案
  [4] 退出

请选择 [1-4]:
```

## 🎨 特色功能

### 1. 智能检测

```bash
🔍 正在检测构建环境...

✓ Cordova 项目检测成功
  应用名称: 喝水打卡
  版本号: 1.1.0
  包名: com.ruthirsty.app

✓ Cordova CLI: 13.0.0
✓ Android SDK 已配置
✓ Git 仓库: https://github.com/...
```

### 2. 自动推送

- 检测未提交的更改
- 自动添加和提交
- 推送到远程仓库
- 触发 GitHub Actions

### 3. 智能建议

根据环境状态提供最优建议：
- 有 SDK → 本地构建
- 无 SDK + 有 Git → GitHub Actions
- 无环境 → 配置指南

### 4. 快捷链接

- 自动生成 Actions URL
- 尝试在浏览器中打开
- 提供清晰的下载步骤

## 📖 相关文档

工具会自动引导到相关文档：

- `ANDROID_BUILD_GUIDE.md` - 本地环境配置
- `GITHUB_ACTIONS_GUIDE.md` - 云构建指南
- `HOW_TO_BUILD_APK.md` - 完整构建方案
- `CORDOVA_BUILD_GUIDE.md` - Cordova 详细文档

## 🔧 高级用法

### 直接指定方案

虽然工具会自动检测，但你也可以：

```bash
# 强制使用本地构建
./cordova-build.sh debug

# 手动推送触发云构建
git push origin main

# 查看文档
less GITHUB_ACTIONS_GUIDE.md
```

### 自定义配置

编辑 `apk-builder` 脚本自定义：
- 颜色方案
- 检测逻辑
- 菜单选项
- 默认行为

## 💡 使用技巧

### 1. 快速构建

如果环境已配置，只需：
```bash
./apk-builder
# 输入 1
```

### 2. 云构建模式

在 Codespaces 或无 SDK 环境：
```bash
./apk-builder
# 选择 GitHub Actions 方案
# 输入 1 自动推送构建
```

### 3. 查看帮助

任何时候都可以选择查看文档选项

### 4. 批处理

可以配合其他脚本使用：
```bash
# 自动化构建流程
./apk-builder && notify-send "构建完成"
```

## 🎯 与其他工具对比

| 工具 | 特点 | 适用场景 |
|------|------|---------|
| **apk-builder** | 智能检测，交互式 | 任何环境，自动选择 |
| cordova-build.sh | 本地构建，详细输出 | 有 Android SDK |
| GitHub Actions | 云构建，自动化 | 无本地环境 |

## 🐛 故障排查

### 问题 1: 脚本无法执行
```bash
chmod +x apk-builder
./apk-builder
```

### 问题 2: 检测失败
- 确保在 Cordova 项目根目录
- 检查 config.xml 是否存在

### 问题 3: 推送失败
- 检查 Git 仓库配置
- 确保有推送权限

## 🎉 总结

**APK Builder** 提供了类似 skill 的体验：

- ✅ 一键启动
- ✅ 智能检测
- ✅ 自动选择方案
- ✅ 交互式操作
- ✅ 清晰的反馈
- ✅ 详细的指导

**现在就试试吧！**

```bash
./apk-builder
```
