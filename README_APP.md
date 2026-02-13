# 喝水打卡 Cordova 应用

一个简单实用的喝水打卡应用，帮助你养成良好的喝水习惯。

## ✨ 功能特性

- 💧 **一键打卡** - 快速记录喝水
- 📊 **数据统计** - 显示今日打卡次数和总饮水量
- ⏰ **时间记录** - 每次打卡自动记录时间
- 💾 **本地存储** - 数据持久化保存，不会丢失
- 📱 **响应式设计** - 完美适配手机屏幕
- 🎨 **美观界面** - 渐变色设计，视觉效果出众

## 📱 应用截图

应用包含以下功能模块：
- 顶部显示当前日期
- 统计卡片（今日打卡次数、今日饮水量）
- 打卡按钮（可自定义饮水量 50-1000ml）
- 记录列表（显示打卡时间和饮水量）
- 清空按钮（清空今日所有记录）

## 🚀 快速开始

### 方式一：浏览器预览（推荐用于开发测试）

```bash
# 安装依赖
npm install

# 启动开发服务器
npm start
```

访问 http://localhost:8080 即可在浏览器中预览应用。

### 方式二：构建 Android APK

#### 环境要求
- Node.js 14+
- JDK 8 或 JDK 11
- Android SDK (API Level 22+)
- Gradle

#### 构建步骤

1. **安装 Cordova CLI**
```bash
npm install -g cordova
```

2. **添加 Android 平台**
```bash
cordova platform add android
```

3. **构建调试版本**
```bash
cordova build android
```

生成的 APK 位于：`platforms/android/app/build/outputs/apk/debug/app-debug.apk`

4. **构建发布版本**
```bash
cordova build android --release
```

5. **安装到设备**
```bash
# 连接 Android 设备后运行
cordova run android
```

## 📂 项目结构

```
RUthirsty-cordova/
├── config.xml              # Cordova 配置文件
├── package.json           # npm 配置
├── www/                   # Web 资源目录
│   ├── index.html        # 主页面
│   ├── css/
│   │   └── index.css     # 样式文件
│   └── js/
│       └── index.js      # 应用逻辑
├── platforms/            # 平台代码（自动生成）
└── plugins/              # 插件（自动生成）
```

## 💡 使用说明

1. **打卡喝水**
   - 点击"打卡喝水"按钮记录一次喝水
   - 默认饮水量为 200ml，可以在输入框中修改（50-1000ml）

2. **查看统计**
   - 顶部卡片显示今日打卡次数和总饮水量
   - 数据每日自动重置

3. **查看记录**
   - 记录列表显示每次打卡的时间和饮水量
   - 最新的记录显示在最上方

4. **清空记录**
   - 点击"清空"按钮可以删除今日所有记录
   - 清空前会弹出确认对话框

## 💾 数据存储

应用使用 `localStorage` 存储打卡记录，数据格式如下：

```json
{
  "date": "2026-02-13",
  "time": "14:30",
  "timestamp": 1707818400000,
  "amount": 200
}
```

注意：
- 数据存储在设备本地
- 卸载应用会清空数据
- 每天自动过滤只显示当日记录

## 🔧 常见问题

**Q: 如何修改默认饮水量？**
A: 在打卡按钮下方的输入框中修改数值即可。

**Q: 数据会同步到云端吗？**
A: 当前版本仅支持本地存储，未来可能添加云同步功能。

**Q: 构建失败怎么办？**
A: 请检查：
- Android SDK 是否正确安装
- ANDROID_HOME 环境变量是否设置
- 运行 `cordova requirements android` 检查依赖

**Q: 应用无法安装？**
A: 请在设备设置中开启"允许安装未知来源应用"。

## 📝 开发建议

- 浏览器测试：直接打开 `www/index.html` 即可快速测试
- 修改样式：编辑 `www/css/index.css`
- 修改逻辑：编辑 `www/js/index.js`
- 修改配置：编辑 `config.xml`

## 📄 许可证

MIT License

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**祝你每天都能喝够水，保持健康！** 💧
