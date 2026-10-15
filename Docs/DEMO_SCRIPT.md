# StudySpot - Five-Minute Live Demonstration Script

**Target Time:** 5 Minutes  
**Presenter:** Abhilash K A T W (IT22081698)  
**App:** StudySpot (SE4041 Assignment 02 - Swift, Part A)  
**Setup:** iPhone 15/16 Simulator running iOS 17+, StudySpot installed, Demo Mode enabled in Settings.

---

## Timeline & Scene Overview

| Time | Scene / Screen | Key Actions & Verbal Talking Points |
|---|---|---|
| **0:00 - 1:00** | **Screen 01: Explore** | App launch, brand identity, search debouncing, category chips, region selector, and bookmarking a venue. |
| **1:00 - 2:00** | **Screen 02: Map** | Interactive MapKit pins, "Search this area" in visible frame, "Near Me" location trigger, and bottom preview card. |
| **2:00 - 3:00** | **Screen 03: Place Details** | Observation chips, editing personal Wi-Fi/power notes, Apple Maps directions handoff, and logging a study session. |
| **3:00 - 3:45** | **Screen 04: Saved Places** | Personal note preview, live filtering, swipe-to-unsave, and explaining safe unfavourite semantics. |
| **3:45 - 4:30** | **Screen 05: My Progress** | Real-time aggregate calculation, period filter, weekly study bar chart, and editing/deleting a session. |
| **4:30 - 5:00** | **About & Architecture** | Student authorship credentials, demo mode toggle, Core Data SQLite backing, and concluding statement. |

---

## Detailed Step-by-Step Script

### Minute 1: Introduction & Discovery on Explore (0:00 - 1:00)
- **Visual Action:** Open StudySpot on the simulator. Point to the top brand header: StudySpot with the Book & Pin logo and subtitle *"Find a place. Find your focus."*
- **Spoken Script:**
  > *"Hello, my name is Abhilash, and this is StudySpot, an advanced native iOS application built in Swift and SwiftUI for SE4041 Assignment 2. The app helps students find productive study spaces, record personal study observations, and track their study sessions.
  > Here on the Explore screen, we see a warm study banner and curated study spots in Colombo. Notice the category filter chips: tapping 'Cafés' filters for coffee shops like Leaf & Latte; tapping 'Libraries' reveals quiet reading spaces like Quiet Corner Library. The search bar uses MKLocalSearch with active debouncing and cancellation so queries never lag or overwrite."*
- **Visual Action:** Tap the bookmark icon on *Leaf & Latte*. Notice the smooth haptic transition indicating it has been saved to Core Data.

---

### Minute 2: Interactive Map Exploration (1:00 - 2:00)
- **Visual Action:** Switch to the **Map** tab.
- **Spoken Script:**
  > *"Next, let's explore the Map tab. StudySpot integrates real MapKit maps with custom markers distinguishing libraries (books) and cafes (coffee cups). When I tap a marker—such as Quiet Corner Library—the pin highlights with a warm gold accent and a preview card appears at the bottom.
  > If I pan the camera to a new neighborhood and tap 'Search this area', the app queries Apple's Point of Interest index for the exact bounding region visible on screen. Tapping the 'Near Me' crosshair requests Core Location When-In-Use authorization and smoothly centers on the student's coordinates."*
- **Visual Action:** Tap the **"View place"** button on the bottom preview card.

---

### Minute 3: Place Details & Logging a Session (2:00 - 3:00)
- **Visual Action:** Arrive on the **Place Details** screen.
- **Spoken Script:**
  > *"The Place Details screen displays verified venue metadata alongside private student observations. Note the three observation chips: Wi-Fi: Available, Power: Plentiful, and Noise: Quiet. MapKit does not guess these suitability traits—they are personal student notes saved locally.
  > Tapping 'Directions' uses public Apple Maps APIs to hand off walking navigation directly to the Maps app.
  > Now let's log a study session. I tap '+ Log study session', select 45 minutes and 4 stars focus, and enter the note: 'Reviewed mobile architecture'. Tapping Save immediately commits the session to our Core Data SQLite store."*
- **Visual Action:** Tap Save. Show that the Recent session section now displays *45 min · Focus 4/5*.

---

### Minute 4: Saved Places & Safe Unfavourite (3:00 - 3:45)
- **Visual Action:** Tap the **Saved** tab.
- **Spoken Script:**
  > *"In the Saved Places tab, our bookmarked venues appear with our custom notes: 'Your note: Best for reading and solo work'. The search field lets students search through their saved spots instantly.
  > Here is a crucial architectural design: if I swipe left on Leaf & Latte to Unsave it, the favourite bookmark is removed, but its completed study session history is safely preserved in Core Data. A venue is never deleted automatically just because you remove it from your favourites."*

---

### Minute 5: My Progress, Session CRUD & Conclusion (3:45 - 5:00)
- **Visual Action:** Switch to the **Progress** tab.
- **Spoken Script:**
  > *"In the My Progress tab, all statistics are dynamically derived from our stored Core Data sessions—never hardcoded. The hero card displays total study time: 3h 30m. The stat grid highlights 5 completed sessions and an average focus of 4/5 stars. Below, an accessible weekly bar chart visualizes study minutes across each day of the week.
  > Every session supports full CRUD operations: I can tap the pencil icon to edit duration or focus rating, or delete a session using the menu. Any modification instantly recalculates our total study time and chart bars.
  > Finally, tapping the gear icon opens About StudySpot, verifying my student ID IT22081698 and module details, along with the isolated Demo Mode toggle."*
- **Concluding Statement:**
  > *"StudySpot combines MapKit discovery with durable Core Data persistence and accessible SwiftUI design to solve a real student problem. Thank you."*
