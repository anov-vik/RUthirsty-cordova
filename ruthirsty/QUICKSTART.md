# 喝水打卡应用 - 快速开始指南

## 📱 应用预览

访问测试页面查看应用效果:
```bash
cd ruthirsty/www
python3 -m http.server 8080
```
然后在浏览器打开: http://localhost:8080/test.html

## 🚀 快速开始

### 方法1: 使用构建脚本 (推荐)

```bash
cd ruthirsty
chmod +x build.sh
./build.sh
```

按照提示选择:
- 选项 1: 构建调试版 APK
- 选项 2: 构建发布版 APK
- 选项 3: 直接在已连接的设备上运行
- 选项 4: 在浏览器中测试

### 方法2: 手动命令

```bash
# 构建调试版
cd ruthirsty
cordova build android

# 生成的APK位置
# platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

## 📋 前置要求

### 必需软件

1. **Node.js 和 npm**
   ```bash
   node --version  # v14 或更高
   npm --version
   ```

2. **Cordova CLI**
   ```bash
   npm install -g cordova
   ```

3. **Java JDK** (构建 Android 需要)
   ```bash
   java -version  # JDK 11 或更高
   ```

4. **Android Studio** (构建 Android 需要)
   - 下载: https://developer.android.com/studio
   - 安装 Android SDK
   - 设置环境变量

### 环境变量设置

**Linux/Mac:**
```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

**Windows:**
```
系统变量:
ANDROID_HOME = C:\Users\你的用户名\AppData\Local\Android\Sdk

Path 添加:
%ANDROID_HOME%\tools
%ANDROID_HOME%\platform-tools
```

## 🎯 应用功能

### 1. 喝水打卡
- 点击中间的圆形水滴按钮
- 即时记录当前时间
- 按钮会播放动画反馈

### 2. 今日统计
- 顶部显示今日喝水总次数
- 实时更新
- 零点自动重置

### 3. 历史记录
- 显示所有喝水记录
- 包含日期和时间
- 按时间倒序排列
- 支持滚动查看

### 4. 数据持久化
- 使用 localStorage 存储
- 关闭应用不丢失
- 卸载应用会清空

## 📱 安装到手机

### 调试版 APK 安装

1. 构建 APK:
   ```bash
   cordova build android
   ```

2. 找到 APK 文件:
   ```
   platforms/android/app/build/outputs/apk/debug/app-debug.apk
   ```

3. 传输到手机:
   - 使用 USB 数据线
   - 或发送到微信/邮箱
   - 或使用文件共享工具

4. 在手机上安装:
   - 允许"安装未知来源应用"
   - 点击 APK 文件
   - 按照提示完成安装

### 直接运行到设备

```bash
# 1. 连接手机到电脑 (USB)
# 2. 手机开启开发者选项和USB调试
# 3. 运行命令
cordova run android
```

## 🎨 界面说明

- **渐变背景**: 紫色到蓝色渐变
- **打卡按钮**: 圆形水滴图标,点击有缩放动画
- **记录卡片**: 紫色渐变卡片,新记录有滑入动画
- **响应式设计**: 适配各种屏幕尺寸

## 🔧 自定义配置

### 修改应用名称

编辑 `config.xml`:
```xml
<name>你的应用名</name>
```

### 修改应用ID

编辑 `config.xml`:
```xml
<widget id="com.yourcompany.app" ...>
```

### 修改版本号

编辑 `config.xml`:
```xml
<widget ... version="1.0.1" ...>
```

## 📊 数据格式

应用使用 localStorage 存储,数据格式:

```json
[
  {
    "id": 1738313600000,
    "timestamp": "2026-01-31T08:00:00.000Z",
    "date": "2026/1/31",
    "time": "16:00"
  }
]
```

## 🐛 故障排除

### 问题: cordova 命令未找到
**解决**:
```bash
npm install -g cordova
```

### 问题: ANDROID_HOME 未设置
**解决**: 按照上面的环境变量设置步骤操作

### 问题: 构建失败
**解决**: 运行检查命令
```bash
cordova requirements android
```

### 问题: 应用崩溃
**解决**:
1. 检查浏览器控制台错误
2. 清除应用数据重试
3. 查看 logcat 日志

## 📞 技术支持

- 项目位置: `/workspaces/RUthirsty-cordova/ruthirsty/`
- 测试URL: http://localhost:8080/test.html
- Cordova文档: https://cordova.apache.org/docs/

## 📝 项目文件说明

```
ruthirsty/
├── www/                      # 应用源代码
│   ├── index.html           # 主界面 (Cordova版)
│   ├── test.html            # 测试界面 (浏览器版)
│   ├── css/
│   │   └── index.css        # 样式文件
│   └── js/
│       └── index.js         # 核心逻辑
├── platforms/               # 平台代码
│   └── android/            # Android平台
├── config.xml              # Cordova配置
├── build.sh                # 构建脚本
├── package.json            # 依赖配置
└── README.md               # 完整文档
```

## ✨ 功能扩展建议

可以添加的功能:
- 每日喝水目标设定
- 喝水提醒通知
- 统计图表展示
- 数据导出功能
- 自定义喝水量记录
- 成就系统
- 分享功能

祝你使用愉快! 💧
