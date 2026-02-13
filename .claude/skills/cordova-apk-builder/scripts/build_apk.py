#!/usr/bin/env python3
"""
Cordova APK Builder - Intelligent build orchestrator
Detects environment and executes the optimal build strategy
"""

import os
import sys
import subprocess
import json
from pathlib import Path

class CordovaAPKBuilder:
    def __init__(self):
        self.project_root = Path.cwd()
        self.has_android_sdk = False
        self.has_git = False
        self.has_github_actions = False
        self.app_info = {}

    def detect_environment(self):
        """Detect Cordova project and available build environments"""
        print("🔍 Detecting environment...")

        # Check if Cordova project
        config_file = self.project_root / "config.xml"
        if not config_file.exists():
            print("❌ Not a Cordova project (config.xml not found)")
            return False

        # Parse app info from config.xml
        try:
            import xml.etree.ElementTree as ET
            tree = ET.parse(config_file)
            root = tree.getroot()
            self.app_info = {
                'name': root.find('name').text if root.find('name') is not None else 'Unknown',
                'version': root.get('version', 'Unknown'),
                'id': root.get('id', 'Unknown')
            }
            print(f"✓ Cordova project: {self.app_info['name']} v{self.app_info['version']}")
        except Exception as e:
            print(f"⚠ Could not parse config.xml: {e}")

        # Check Android SDK
        self.has_android_sdk = bool(os.environ.get('ANDROID_HOME')) and \
                               os.path.exists(os.environ.get('ANDROID_HOME', ''))
        print(f"{'✓' if self.has_android_sdk else '✗'} Android SDK: {'Available' if self.has_android_sdk else 'Not found'}")

        # Check Git
        try:
            subprocess.run(['git', 'status'], capture_output=True, check=True)
            self.has_git = True
            print("✓ Git repository: Available")
        except:
            print("✗ Git repository: Not found")

        # Check GitHub Actions
        gh_actions = self.project_root / ".github" / "workflows" / "build-apk.yml"
        self.has_github_actions = gh_actions.exists()
        print(f"{'✓' if self.has_github_actions else '✗'} GitHub Actions: {'Configured' if self.has_github_actions else 'Not configured'}")

        return True

    def recommend_strategy(self):
        """Recommend best build strategy based on environment"""
        print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

        if self.has_android_sdk:
            print("🎯 Recommended: LOCAL BUILD (fastest)")
            print("   You have Android SDK configured")
            return "local"
        elif self.has_github_actions and self.has_git:
            print("🎯 Recommended: GITHUB ACTIONS (no local SDK needed)")
            print("   Cloud build in 3-5 minutes")
            return "github"
        else:
            print("📋 Setup needed: Configure build environment")
            return "setup"

    def execute_local_build(self, build_type="debug"):
        """Execute local Cordova build"""
        print(f"\n🔨 Building {build_type} APK locally...")

        try:
            cmd = ['cordova', 'build', 'android']
            if build_type == "release":
                cmd.append('--release')

            result = subprocess.run(cmd, capture_output=True, text=True)

            if result.returncode == 0:
                print("✅ Build successful!")

                # Find APK
                if build_type == "debug":
                    apk_path = "platforms/android/app/build/outputs/apk/debug/app-debug.apk"
                else:
                    apk_path = "platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk"

                if os.path.exists(apk_path):
                    size = os.path.getsize(apk_path) / (1024 * 1024)
                    print(f"📦 APK: {apk_path}")
                    print(f"📊 Size: {size:.1f} MB")
                    return True
            else:
                print(f"❌ Build failed:\n{result.stderr}")
                return False

        except Exception as e:
            print(f"❌ Error: {e}")
            return False

    def execute_github_build(self):
        """Push code to trigger GitHub Actions build"""
        print("\n📤 Triggering GitHub Actions build...")

        try:
            # Check for uncommitted changes
            status = subprocess.run(['git', 'status', '--porcelain'],
                                  capture_output=True, text=True)

            if status.stdout.strip():
                print("📝 Committing changes...")
                subprocess.run(['git', 'add', '-A'], check=True)
                subprocess.run(['git', 'commit', '-m', 'Build APK'], check=True)

            # Push to trigger build
            print("⬆️ Pushing to GitHub...")
            result = subprocess.run(['git', 'push', 'origin', 'main'],
                                  capture_output=True, text=True)

            if result.returncode != 0:
                # Try master branch
                result = subprocess.run(['git', 'push', 'origin', 'master'],
                                      capture_output=True, text=True)

            if result.returncode == 0:
                # Get repo URL
                remote = subprocess.run(['git', 'remote', 'get-url', 'origin'],
                                      capture_output=True, text=True)
                repo_url = remote.stdout.strip().replace('.git', '')
                actions_url = f"{repo_url}/actions"

                print("✅ Code pushed successfully!")
                print(f"\n📥 View build progress:")
                print(f"   {actions_url}")
                print("\n💡 Download APK:")
                print("   1. Wait for build to complete (3-5 min)")
                print("   2. Click on the workflow")
                print("   3. Scroll to 'Artifacts' section")
                print("   4. Download ZIP and extract APK")
                return True
            else:
                print(f"❌ Push failed: {result.stderr}")
                return False

        except Exception as e:
            print(f"❌ Error: {e}")
            return False

    def show_setup_guide(self):
        """Show setup instructions"""
        print("\n📚 Setup Guide:")
        print("\nOption 1: Local Build")
        print("  1. Install Android Studio")
        print("  2. Set ANDROID_HOME environment variable")
        print("  3. Run: cordova build android")
        print("\nOption 2: GitHub Actions")
        print("  1. Add .github/workflows/build-apk.yml")
        print("  2. Push code to GitHub")
        print("  3. Download APK from Actions page")
        print("\nFor detailed instructions, see documentation")

def main():
    builder = CordovaAPKBuilder()

    if not builder.detect_environment():
        sys.exit(1)

    strategy = builder.recommend_strategy()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

    if strategy == "local":
        # Interactive choice
        print("Build type:")
        print("  1. Debug (recommended, can install directly)")
        print("  2. Release (needs signing)")
        choice = input("\nSelect [1-2]: ").strip() or "1"

        build_type = "release" if choice == "2" else "debug"
        builder.execute_local_build(build_type)

    elif strategy == "github":
        print("Proceed with GitHub Actions build? [Y/n]: ", end="")
        choice = input().strip().lower()

        if choice in ['', 'y', 'yes']:
            builder.execute_github_build()
        else:
            print("Cancelled")

    else:
        builder.show_setup_guide()

if __name__ == "__main__":
    main()
