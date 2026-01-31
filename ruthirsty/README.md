# 喝水打卡应用 (RUthirsty)

这是一个基于 Cordova 开发的喝水打卡应用，帮助你养成良好的喝水习惯。

## 功能特点

- 💧 **一键打卡**: 点击圆形按钮即可记录喝水
- 📊 **今日统计**: 实时显示今日喝水次数
- 📝 **历史记录**: 展示所有喝水记录，包括日期和时间
- 💾 **本地存储**: 使用 localStorage 持久化保存数据
- 🎨 **美观界面**: 渐变色背景，流畅的动画效果

## 项目结构

```
ruthirsty/
├── www/                    # 应用源代码
│   ├── index.html         # 主界面
│   ├── css/
│   │   └── index.css      # 样式文件
│   └── js/
│       └── index.js       # 业务逻辑
├── platforms/             # 平台相关文件
│   └── android/          # Android 平台
├── config.xml            # Cordova 配置文件
└── package.json          # 项目依赖

```

## 安装依赖

```bash
# 安装 Node.js 和 npm (如果还没安装)

# 全局安装 Cordova CLI
npm install -g cordova

# 进入项目目录
cd ruthirsty

# 安装项目依赖
npm install
```

## 在浏览器中测试

```bash
# 启动开发服务器
cordova serve

# 在浏览器访问 http://localhost:8000
```

## 构建 Android 应用

### 前置要求

1. **安装 Java JDK**
   - 下载并安装 JDK 11 或更高版本
   - 设置 JAVA_HOME 环境变量

2. **安装 Android Studio**
   - 下载并安装 Android Studio
   - 安装 Android SDK (API Level 33 或更高)
   - 设置 ANDROID_HOME 环境变量

3. **配置环境变量**
   ```bash
   # Linux/Mac
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

   # Windows (在系统环境变量中设置)
   ANDROID_HOME = C:\Users\YourName\AppData\Local\Android\Sdk
   ```

### 构建 APK

```bash
# 添加 Android 平台 (已添加可跳过)
cordova platform add android

# 构建调试版本
cordova build android

# 构建发布版本
cordova build android --release

# 生成的 APK 位置
# 调试版: platforms/android/app/build/outputs/apk/debug/app-debug.apk
# 发布版: platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk
```

## 在 Android 设备上运行

### 方法一: 直接运行

```bash
# 连接 Android 设备并启用 USB 调试
# 运行应用
cordova run android
```

### 方法二: 安装 APK

1. 构建 APK (见上文)
2. 将 APK 文件传输到 Android 设备
3. 在设备上允许安装未知来源的应用
4. 点击 APK 文件进行安装

## 应用使用说明

1. **打卡喝水**
   - 点击中间的圆形水滴按钮
   - 按钮会有动画反馈
   - 今日次数自动增加

2. **查看记录**
   - 向下滚动查看历史记录
   - 每条记录显示日期和时间
   - 记录按时间倒序排列(最新的在上)

3. **数据存储**
   - 所有数据存储在本地
   - 卸载应用会清空数据
   - 建议定期导出备份

## 技术栈

- **框架**: Apache Cordova 13.0.0
- **平台**: Android (API 35)
- **存储**: localStorage
- **界面**: HTML5 + CSS3 + JavaScript (ES6)

## 兼容性

- Android 6.0 (API 23) 及以上
- 支持各种屏幕尺寸
- 支持深色模式

## 自定义配置

编辑 `config.xml` 可修改:
- 应用名称
- 应用 ID
- 版本号
- 应用图标
- 启动画面

## 故障排除

### 构建失败

1. 检查 Java 和 Android SDK 是否正确安装
2. 确认环境变量设置正确
3. 运行 `cordova requirements` 检查依赖

### 应用崩溃

1. 查看 Android logcat 日志
2. 确认 Cordova 版本兼容
3. 清除应用数据重试

## 开发者

- 项目名称: RUthirsty
- 包名: com.ruthirsty.app
- 版本: 1.0.0

## 许可证

Apache License 2.0
