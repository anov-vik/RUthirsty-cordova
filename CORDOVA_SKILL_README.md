# Cordova APK Builder Skill - Claude Code Skill

## ✅ Skill Successfully Created!

The `cordova-apk-builder` **Claude Code Skill** has been created in your project directory and is ready to use.

> **Note**: This is different from the `apk-builder` bash script. This is a Claude Code Skill that can be invoked automatically when you ask Claude to build APKs in future conversations.

### 📁 Skill Location

```
/workspaces/RUthirsty-cordova/.claude/skills/cordova-apk-builder/
├── SKILL.md                           # Main skill instructions (loaded into Claude's context)
├── cordova-apk-builder.skill          # Packaged skill file (distributable ZIP)
├── scripts/
│   └── build_apk.py                   # Intelligent build orchestrator (208 lines)
└── references/
    ├── setup.md                       # Environment setup guide
    └── troubleshooting.md             # Common issues and solutions
```

### 🎯 What This Skill Does

This is a **Claude Code Skill** that teaches Claude how to automate building Android APK files from Cordova projects. When you ask Claude to build an APK in the future, it will automatically:

1. **Detect environment** - Check for Android SDK, Git, GitHub Actions
2. **Recommend strategy** - Suggest local build vs cloud build based on available tools
3. **Execute build** - Run the build process with detailed feedback
4. **Provide troubleshooting** - Guide you through common issues

### 🚀 How to Use the Skill

#### Automatic Activation (Recommended)

In future Claude Code sessions, simply ask:
- "Build my APK"
- "Package my Cordova app"
- "Create an Android APK"
- "Generate APK from my app"
- "Build Android package"

Claude will automatically detect that you have a Cordova project and use this skill to help you build the APK.

#### Manual Script Execution

You can also run the Python script directly:

```bash
cd /workspaces/RUthirsty-cordova
python .claude/skills/cordova-apk-builder/scripts/build_apk.py
```

The script will:
1. Detect your Cordova project (parse config.xml)
2. Check available build tools (Android SDK, Git, GitHub Actions)
3. Recommend the best build strategy
4. Guide you through the build process interactively

### 📊 Skill Structure

#### SKILL.md (Main Instructions)
- **Loaded when**: Claude detects you want to build an APK
- **Contains**: Workflow steps, strategy decision tree, quick reference commands
- **Size**: ~4.7 KB (concise and context-efficient)

#### scripts/build_apk.py (Build Orchestrator)
- **Purpose**: Intelligent environment detection and build execution
- **Features**:
  - Parses config.xml for app metadata
  - Detects Android SDK (ANDROID_HOME)
  - Checks Git repository and GitHub Actions configuration
  - Recommends optimal build strategy (local vs cloud)
  - Executes builds with progress feedback
- **Usage**: Can be executed without loading into context

#### references/setup.md (Setup Guide)
- **Loaded when**: Claude needs to help you configure build environment
- **Contains**:
  - Platform-specific setup (Windows, macOS, Linux)
  - Android SDK installation and configuration
  - GitHub Actions workflow template
  - APK signing for release builds
  - Cordova CLI commands

#### references/troubleshooting.md (Problem Solutions)
- **Loaded when**: Build fails or errors occur
- **Contains**:
  - ANDROID_HOME configuration issues
  - Gradle download timeouts (China mirror setup)
  - SDK licenses not accepted
  - Java version mismatches
  - APK installation failures
  - GitHub Actions debugging

### 📦 Current Project Status

Your **喝水打卡** (Water Tracking) app:
- ✅ Cordova project configured (config.xml)
- ✅ Git repository initialized
- ✅ GitHub Actions workflow configured (`.github/workflows/build-apk.yml`)
- ❌ Android SDK not available locally (running in GitHub Codespaces)

**Recommended build method**: GitHub Actions (cloud build)

### 🏗️ Build Strategies

The skill supports three build strategies:

#### 1. Local Build (Fastest)
- **Requirements**: Android SDK installed, ANDROID_HOME set
- **Time**: 1-2 minutes
- **Output**: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`
- **Command**: `cordova build android`

#### 2. GitHub Actions (No SDK Needed)
- **Requirements**: Git repository, `.github/workflows/build-apk.yml` configured
- **Time**: 3-5 minutes
- **Output**: Download from GitHub Actions artifacts
- **Command**: `git push origin main` (triggers workflow)

#### 3. Setup Required
- **When**: No build environment available
- **Action**: Skill provides setup guides from references/

### 🎁 Distributing the Skill

The packaged `cordova-apk-builder.skill` file is a distributable ZIP that can be shared with others:

**To share:**
1. Send the `cordova-apk-builder.skill` file
2. Recipient places it in their `.claude/skills/` directory
3. Claude automatically recognizes and uses it when building APKs

**File contents:**
- All necessary instructions (SKILL.md)
- Build orchestration script (build_apk.py)
- Setup and troubleshooting references

### 📚 Skill Design Principles

This skill follows Claude Code Skill best practices:

1. **Progressive Disclosure** - Three-level loading system:
   - Metadata (name + description): Always in context (~100 words)
   - SKILL.md body: Loaded when skill triggers (<500 lines)
   - References: Loaded as needed by Claude

2. **Concise Instructions** - SKILL.md is lean (135 lines)
   - Assumes Claude is smart, only adds non-obvious procedural knowledge
   - Detailed content split into reference files

3. **Appropriate Degrees of Freedom** - Medium freedom approach:
   - Script for deterministic environment detection
   - Text instructions for flexible build execution
   - References for detailed troubleshooting

### 🔄 Comparison with apk-builder Bash Script

You now have TWO tools for building APKs:

| Tool | Type | Usage | Best For |
|------|------|-------|----------|
| **apk-builder** | Bash script | `./apk-builder` | Quick interactive builds |
| **cordova-apk-builder skill** | Claude Skill | Ask Claude to build | Guided, AI-assisted builds |

**When to use which:**
- **Use apk-builder** when you want quick, interactive menu-driven builds
- **Use the skill** when you want Claude to guide you through the process, handle errors, and provide context-aware help

### 🎯 Example Usage Scenarios

#### Scenario 1: First-time APK build
```
You: "I want to build an APK from my Cordova app"

Claude: [Loads cordova-apk-builder skill]
        [Reads config.xml, detects environment]
        "I see you're working on '喝水打卡' v1.1.0. Since you're in GitHub
        Codespaces without local Android SDK, I recommend using GitHub Actions
        for cloud build. Would you like me to trigger the build?"
```

#### Scenario 2: Build error troubleshooting
```
You: "The APK build failed with ANDROID_HOME not found"

Claude: [Loads troubleshooting.md reference]
        "This error means the Android SDK environment variable isn't set.
        Here's how to fix it..."
        [Provides platform-specific solution]
```

#### Scenario 3: Setting up build environment
```
You: "How do I set up my machine to build Cordova APKs?"

Claude: [Loads setup.md reference]
        "I'll guide you through setting up the Android SDK. What platform
        are you on? Windows, macOS, or Linux?"
        [Provides step-by-step instructions]
```

### 🛠️ Maintenance and Updates

To update the skill:

1. **Edit files** in `.claude/skills/cordova-apk-builder/`
2. **Repackage** using:
   ```bash
   python /home/codespace/.claude/plugins/cache/anthropic-agent-skills/example-skills/*/skills/skill-creator/scripts/package_skill.py \
     /workspaces/RUthirsty-cordova/.claude/skills/cordova-apk-builder
   ```
3. **Redistribute** the new `cordova-apk-builder.skill` file

### 📖 Additional Resources

**Skill Creator Documentation**: See `.claude/plugins/.../skill-creator/` for:
- Skill creation best practices
- Progressive disclosure patterns
- Bundled resource guidelines

**Project Documentation**:
- `APK_BUILDER_GUIDE.md` - Interactive bash script guide
- `HOW_TO_BUILD_APK.md` - Complete build solutions
- `ANDROID_BUILD_GUIDE.md` - Local environment setup
- `GITHUB_ACTIONS_GUIDE.md` - Cloud build guide

---

**Skill Created**: February 13, 2026
**For Project**: 喝水打卡 v1.1.0 (RUthirsty Cordova App)
**Repository**: https://github.com/anov-vik/RUthirsty-cordova
