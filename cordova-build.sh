#!/bin/bash
# Cordova APK 自动构建脚本
# 功能：自动检查环境、构建APK、报告结果

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 图标
CHECKMARK="${GREEN}✓${NC}"
CROSS="${RED}✗${NC}"
INFO="${BLUE}ℹ${NC}"
WARNING="${YELLOW}⚠${NC}"
ROCKET="${PURPLE}🚀${NC}"

# 打印函数
print_header() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${PURPLE}Cordova APK Builder${NC} - 自动化构建工具         ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}\n"
}

print_step() {
    echo -e "${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${CHECKMARK} $1"
}

print_error() {
    echo -e "${CROSS} $1"
}

print_warning() {
    echo -e "${WARNING} $1"
}

print_info() {
    echo -e "${INFO} $1"
}

# 错误处理
error_exit() {
    echo -e "\n${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CROSS} 构建失败: $1"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    exit 1
}

# 显示帮助信息
show_help() {
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  debug     构建调试版本 (默认)"
    echo "  release   构建发布版本"
    echo "  clean     清理构建缓存后重新构建"
    echo "  run       构建后自动安装到设备"
    echo "  help      显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0              # 构建调试版本"
    echo "  $0 release      # 构建发布版本"
    echo "  $0 clean        # 清理后构建"
    echo "  $0 run          # 构建并安装"
    exit 0
}

# 解析参数
BUILD_TYPE="debug"
CLEAN_BUILD=false
AUTO_RUN=false

case "${1:-}" in
    help|--help|-h)
        show_help
        ;;
    release)
        BUILD_TYPE="release"
        ;;
    clean)
        CLEAN_BUILD=true
        ;;
    run)
        AUTO_RUN=true
        ;;
    debug|"")
        BUILD_TYPE="debug"
        ;;
    *)
        print_error "未知选项: $1"
        echo "使用 '$0 help' 查看帮助"
        exit 1
        ;;
esac

# 开始构建流程
print_header

# 1. 检查是否是 Cordova 项目
print_step "步骤 1/7: 检查 Cordova 项目"
if [ ! -f "config.xml" ]; then
    error_exit "未找到 config.xml，当前目录不是 Cordova 项目"
fi
print_success "找到 Cordova 项目配置"

# 读取应用信息
APP_NAME=$(grep -oP '(?<=<name>)[^<]+' config.xml | head -1)
APP_VERSION=$(grep -oP '(?<=version=")[^"]+' config.xml | head -1)
APP_ID=$(grep -oP '(?<=id=")[^"]+' config.xml | head -1)

print_info "应用名称: ${GREEN}${APP_NAME}${NC}"
print_info "应用版本: ${GREEN}${APP_VERSION}${NC}"
print_info "应用 ID:  ${GREEN}${APP_ID}${NC}"

# 2. 检查 Node.js 和 npm
print_step "\n步骤 2/7: 检查 Node.js 环境"
if ! command -v node &> /dev/null; then
    error_exit "未安装 Node.js，请访问 https://nodejs.org 安装"
fi
NODE_VERSION=$(node -v)
print_success "Node.js 版本: $NODE_VERSION"

if ! command -v npm &> /dev/null; then
    error_exit "未安装 npm"
fi
NPM_VERSION=$(npm -v)
print_success "npm 版本: $NPM_VERSION"

# 3. 检查 Cordova CLI
print_step "\n步骤 3/7: 检查 Cordova CLI"
if ! command -v cordova &> /dev/null; then
    print_warning "未安装 Cordova CLI"
    read -p "是否现在安装? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "正在安装 Cordova CLI..."
        npm install -g cordova || error_exit "Cordova CLI 安装失败"
        print_success "Cordova CLI 安装成功"
    else
        error_exit "需要 Cordova CLI 才能继续"
    fi
fi
CORDOVA_VERSION=$(cordova -v)
print_success "Cordova 版本: $CORDOVA_VERSION"

# 4. 检查 Android 平台
print_step "\n步骤 4/7: 检查 Android 平台"
if [ ! -d "platforms/android" ]; then
    print_warning "未添加 Android 平台"
    print_info "正在添加 Android 平台..."
    cordova platform add android || error_exit "Android 平台添加失败"
    print_success "Android 平台添加成功"
else
    print_success "Android 平台已存在"
fi

# 5. 检查环境依赖
print_step "\n步骤 5/7: 检查环境依赖"
print_info "运行 cordova requirements android..."
echo ""

# 运行 requirements 并捕获输出
REQUIREMENTS_OUTPUT=$(cordova requirements android 2>&1)
REQUIREMENTS_EXIT_CODE=$?

echo "$REQUIREMENTS_OUTPUT"

if [ $REQUIREMENTS_EXIT_CODE -ne 0 ]; then
    print_warning "环境检查发现问题"
    print_info "你可以继续构建，但可能会失败"
    print_info "请确保已安装:"
    echo "  - Java JDK (8 or 11)"
    echo "  - Android SDK"
    echo "  - Gradle"
    echo "  - 设置 ANDROID_HOME 环境变量"
    echo ""
    read -p "是否继续构建? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    print_success "环境依赖检查通过"
fi

# 6. 清理构建（如果需要）
if [ "$CLEAN_BUILD" = true ]; then
    print_step "\n清理构建缓存"
    if [ -d "platforms/android/app/build" ]; then
        rm -rf platforms/android/app/build
        print_success "构建缓存已清理"
    fi
fi

# 7. 开始构建
print_step "\n步骤 6/7: 开始构建 APK"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

BUILD_START_TIME=$(date +%s)

if [ "$BUILD_TYPE" = "release" ]; then
    print_info "构建类型: ${YELLOW}发布版本${NC}"
    cordova build android --release || error_exit "构建失败"
    APK_PATH="platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk"
else
    print_info "构建类型: ${YELLOW}调试版本${NC}"
    cordova build android || error_exit "构建失败"
    APK_PATH="platforms/android/app/build/outputs/apk/debug/app-debug.apk"
fi

BUILD_END_TIME=$(date +%s)
BUILD_DURATION=$((BUILD_END_TIME - BUILD_START_TIME))

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
print_success "构建成功！耗时: ${BUILD_DURATION}秒"

# 8. 检查并显示 APK 信息
print_step "\n步骤 7/7: APK 信息"
if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    print_success "APK 已生成"
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  ${ROCKET} ${PURPLE}构建完成！${NC}                                       ${GREEN}║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}  📦 APK 位置:                                        ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}     ${CYAN}$APK_PATH${NC}"
    echo -e "${GREEN}║${NC}                                                        ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}  📊 文件大小: ${YELLOW}${APK_SIZE}${NC}"
    echo -e "${GREEN}║${NC}                                                        ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
else
    error_exit "未找到 APK 文件"
fi

# 9. 后续操作建议
echo ""
print_info "下一步操作:"

if [ "$BUILD_TYPE" = "release" ]; then
    echo -e "  ${YELLOW}1.${NC} 签名 APK (发布版本需要签名):"
    echo -e "     ${CYAN}jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \\${NC}"
    echo -e "     ${CYAN}  -keystore my-release-key.keystore \\${NC}"
    echo -e "     ${CYAN}  $APK_PATH alias_name${NC}"
    echo ""
    echo -e "  ${YELLOW}2.${NC} 对齐 APK:"
    echo -e "     ${CYAN}zipalign -v 4 $APK_PATH app-aligned.apk${NC}"
else
    echo -e "  ${YELLOW}1.${NC} 安装到设备 (连接 Android 设备):"
    echo -e "     ${CYAN}cordova run android${NC}"
    echo ""
    echo -e "  ${YELLOW}2.${NC} 或手动安装:"
    echo -e "     ${CYAN}adb install -r $APK_PATH${NC}"
fi

echo ""
echo -e "  ${YELLOW}3.${NC} 在模拟器中测试:"
echo -e "     ${CYAN}cordova emulate android${NC}"

# 自动运行（如果指定）
if [ "$AUTO_RUN" = true ]; then
    echo ""
    print_step "自动安装到设备"

    # 检查设备
    if command -v adb &> /dev/null; then
        DEVICE_COUNT=$(adb devices | grep -v "List" | grep "device" | wc -l)
        if [ $DEVICE_COUNT -gt 0 ]; then
            print_info "发现 $DEVICE_COUNT 个设备"
            cordova run android || print_warning "安装失败"
        else
            print_warning "未发现连接的设备"
        fi
    else
        print_warning "未安装 adb"
    fi
fi

# 构建完成
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${ROCKET} ${GREEN}所有步骤完成！${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
