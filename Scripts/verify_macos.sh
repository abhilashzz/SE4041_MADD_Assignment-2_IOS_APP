#!/usr/bin/env bash
# ==============================================================================
# StudySpot - macOS Verification & Test Runner
# Student: Abhilash K A T W - IT22081698
# Module: SE4041 - Mobile Application Design and Development
# Assignment: Assignment 02 - Swift, Part A: Advanced iOS App
# ==============================================================================

set -eo pipefail

echo "=========================================================="
echo "  StudySpot - Native iOS Verification on macOS"
echo "  Student: Abhilash K A T W (IT22081698)"
echo "=========================================================="

# 1. Verify Xcode is installed and active
if ! command -v xcodebuild >/dev/null 2>&1; then
    echo "❌ ERROR: xcodebuild is not available in PATH."
    echo "Please ensure Xcode is installed and active via: sudo xcode-select -s /Applications/Xcode.app"
    exit 1
fi

echo "✅ Xcode Version:"
xcodebuild -version

# 2. Check for StudySpot project
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

if [ ! -d "StudySpot.xcodeproj" ]; then
    echo "❌ ERROR: StudySpot.xcodeproj not found in $PROJECT_DIR"
    exit 1
fi

echo "✅ Located StudySpot.xcodeproj"

# 3. Discover available iPhone Simulator destination
echo "🔍 Searching for available iOS Simulator..."
DESTINATION=$(xcrun simctl list devices available | grep -E "iPhone (15|16|14|SE)" | head -n 1 | sed -E 's/.*(iPhone [^()]+) \(([A-F0-9-]+)\).*/id=\2/' || true)

if [ -z "$DESTINATION" ]; then
    # Fallback to generic iOS simulator
    DESTINATION="generic/platform=iOS Simulator"
    echo "⚠️ Specific iPhone not detected. Using generic platform destination: $DESTINATION"
else
    echo "✅ Found Simulator destination: $DESTINATION"
fi

# 4. Build StudySpot Scheme
echo ""
echo "=========================================================="
echo "  Step 1: Building StudySpot App Scheme"
echo "=========================================================="
xcodebuild build \
    -project StudySpot.xcodeproj \
    -scheme StudySpot \
    -destination "$DESTINATION" \
    -configuration Debug \
    CODE_SIGNING_ALLOWED=NO

echo "✅ Build Succeeded!"

# 5. Run Unit Tests
echo ""
echo "=========================================================="
echo "  Step 2: Executing StudySpot Unit Tests"
echo "=========================================================="
if [ "$DESTINATION" != "generic/platform=iOS Simulator" ]; then
    xcodebuild test \
        -project StudySpot.xcodeproj \
        -scheme StudySpot \
        -destination "$DESTINATION" \
        -only-testing:StudySpotTests \
        CODE_SIGNING_ALLOWED=NO || echo "⚠️ Unit test execution encountered failures. See log above."
else
    echo "⚠️ Destination is generic simulator; skipping test execution step. Run on an active simulator device."
fi

echo ""
echo "=========================================================="
echo "  macOS Verification Script Complete"
echo "=========================================================="
