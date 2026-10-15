# Mac Tester Handoff Guide: StudySpot

**Student Author:** Abhilash K A T W (IT22081698)  
**App Name:** StudySpot  
**Bundle ID:** `com.abhilashzz.studyspot`  
**Xcode Project:** `StudySpot.xcodeproj`  
**Shared Scheme:** `StudySpot`  
**Minimum Deployment Target:** iOS 17.0  

---

## 1. Quick Start for the Mac Tester

### Step 1: Clone or Extract the Project
```bash
git clone https://github.com/abhilashzz/SE4041_MADD_Assignment-2_IOS_APP.git
cd SE4041_MADD_Assignment-2_IOS_APP
```

### Step 2: Automated Verification Script
Run the automated shell script from Terminal:
```bash
chmod +x Scripts/verify_macos.sh
./Scripts/verify_macos.sh
```
This script will:
1. Detect your active Xcode installation and verify `xcodebuild`.
2. Discover an installed, available iPhone Simulator runtime (e.g., iPhone 15 or 16).
3. Build the `StudySpot` app target cleanly.
4. Execute the unit test suites and output the test summary.

---

## 2. Manual Verification in Xcode

1. Double-click `StudySpot.xcodeproj` to launch Xcode.
2. Confirm the active scheme at the top toolbar is **StudySpot**.
3. Select an **iOS Simulator** target (e.g., *iPhone 15*, *iPhone 16*, or *iPhone SE 3rd Gen* running iOS 17+).
4. **Code Signing:** Simulator testing does not require an Apple Developer Program membership. If building for a physical iPhone, select your own Development Team under `Signing & Capabilities`.
5. **Run App:** Press **Cmd + R** (or click the Play button).
6. **Run Tests:** Press **Cmd + U** to run all 7 unit test suites and the UI test suite.

---

## 3. Manual Functional Verification Checklist

Please verify and record the following interactive test cases:

- [ ] **App Launch:** App opens without crashes into the Explore tab with the brand header and warm study banner.
- [ ] **Explore Search:** Type "Coffee" or "Library". Search filters results smoothly after typing pause.
- [ ] **Category Chips:** Tapping "Libraries" shows library spots; tapping "Cafés" shows coffee spots.
- [ ] **Map View:** Switch to Map tab. Markers appear with books for libraries and cups for cafes.
- [ ] **"Search this area":** Pan map and tap "Search this area". Markers refresh to visible region.
- [ ] **"Near Me":** Tap crosshair button. Grants permission and centers on user/simulated location.
- [ ] **Place Details:** Tap "View place" on bottom card. Details open with back navigation.
- [ ] **Apple Maps Directions:** Tap "Directions" on details. Confirms Apple Maps opens with route.
- [ ] **Edit Observations:** Tap pencil icon. Edit Wi-Fi to "Available", Power to "Plentiful", Noise to "Quiet", save note. Verify chips update immediately.
- [ ] **Log Study Session:** Tap "+ Log study session". Enter 45 min, 4 stars focus, tap Save. Verify recent session updates.
- [ ] **Saved Places:** Open Saved tab. Confirm bookmarked spots appear with your personal note preview.
- [ ] **Safe Unfavourite:** Swipe left and tap Unsave. Verify spot disappears from Saved tab, but its session history remains in Progress!
- [ ] **My Progress:** Open Progress tab. Verify hero study time (e.g., "3h 30m"), session count, average focus, and 7-day weekly bar chart reflect logged sessions.
- [ ] **Dark Mode:** In Simulator, press **Cmd + Shift + A** to toggle Dark Mode. Verify readable contrast across all screens.

---

## 4. Deliverables to Return to the Student

Please return the following artifacts to the student for their viva and report submission:
1. **Exact Xcode Version & macOS Version:** (e.g., *Xcode 15.4 on macOS Sonoma 14.5*).
2. **Simulator Device Name & iOS Version:** (e.g., *iPhone 15 Pro, iOS 17.5*).
3. **Build & Test Output:** Terminal output from `./Scripts/verify_macos.sh` or Xcode test report (`.xcresult`).
4. **Screenshots:** High-resolution screenshots of each of the 5 main screens running on the Simulator.
5. **Short Screen Recording:** A 1-to-2 minute `.mov` or `.mp4` video demonstrating the search -> details -> log session -> progress flow.
