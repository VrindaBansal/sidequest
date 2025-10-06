# Sidequest - Development Log

## Overview

Sidequest is a minimalist daily challenge app with a retro arcade aesthetic that encourages users to try new things and build positive habits. Available as both an iOS app (Swift/SwiftUI) and a web app (HTML/CSS/JavaScript).

---

## iOS Implementation (Swift/SwiftUI)

### Tech Stack
- **Language**: Swift 5.0
- **Framework**: SwiftUI
- **Minimum iOS Version**: iOS 16.0+
- **Development Tool**: Xcode 15+
- **Data Persistence**: UserDefaults (for MVP)

### Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern with a clean separation of concerns:

```
sidequest/
├── Models/
│   ├── Challenge.swift           # Challenge data model
│   └── ChallengeCategory.swift   # Category enum with icons
├── Views/
│   ├── MainView.swift            # Main quest screen
│   └── HistoryView.swift         # Completed quests log
├── ViewModels/
│   └── ChallengeViewModel.swift  # State management & business logic
└── Services/
    └── ChallengeGenerator.swift  # Quest generation logic
```

### Key Features

#### 1. **Daily Quest Generation**
- Generates one random challenge per day at midnight
- 6 categories: Social, Creative, Wellness, Adventure, Learning, Kindness
- 5+ unique challenges per category

#### 2. **Category-Specific Animations**
Each quest type has a unique animation when loading:
- **Social** 💙 - Bounce animation
- **Creative** 💜 - Spin animation (360° rotation)
- **Wellness** 💚 - Pulse animation (scale up/down)
- **Adventure** 🧡 - Shake animation (rapid side-to-side)
- **Learning** 💙 - Fade/scale animation
- **Kindness** 💗 - Float animation (up + scale)

#### 3. **Quest Completion Flow**
1. Tap "COMPLETE" button
2. Green flash animation overlay
3. Quest saved to history
4. **Auto-generate new quest** with category animation
5. New quest appears immediately

#### 4. **Mission Log (History View)**
- Arcade "high score screen" aesthetic
- Displays all completed quests (newest first)
- Shows completion count and success rate
- Color-coded by category
- Persistent storage using UserDefaults

#### 5. **Retro Arcade UI**
- Black background with neon colors
- Monospaced "arcade cabinet" fonts
- Pixel-style borders (thick 4px strokes)
- High-contrast color palette per category
- Minimalist, distraction-free design

### What I Learned

#### Swift/SwiftUI Fundamentals
- **@StateObject vs @ObservedObject**: Understanding when to create vs observe view models
- **@Published properties**: Reactive UI updates when data changes
- **@AppStorage**: Simple key-value persistence with UserDefaults wrapper
- **Codable protocol**: Encoding/decoding structs to JSON for storage
- **NavigationStack**: Modern navigation in SwiftUI (iOS 16+)

#### State Management
- Single source of truth with `ChallengeViewModel`
- Using `ObservableObject` for centralized state
- Passing view models between views via `@ObservedObject`

#### Animations
- SwiftUI's declarative animation system with `withAnimation`
- Chaining animations with `DispatchQueue.main.asyncAfter`
- Transform modifiers: `.offset()`, `.rotationEffect()`, `.scaleEffect()`
- Spring animations: `.spring(response:dampingFraction:)`

#### Data Persistence
- `UserDefaults` for simple key-value storage
- `JSONEncoder`/`JSONDecoder` for complex objects
- `ISO8601DateFormatter` for date serialization
- Checking if dates are "today" with `Calendar.isDateInToday()`

#### SwiftUI Layout
- `VStack`, `HStack`, `ZStack` for composable layouts
- `.sheet()` modifier for modal presentations
- `Spacer()` for flexible spacing
- `.padding()` and `.background()` modifiers

### How It Works

#### Challenge Generation Logic
```swift
1. Check if current challenge is from today
   - If yes: Display existing challenge
   - If no: Generate new challenge

2. Generate new challenge:
   - Filter enabled categories
   - Pick random category
   - Pick random challenge from that category
   - Create Challenge object with current date
   - Save to UserDefaults

3. Display challenge with category-specific styling
```

#### Animation System
Each category triggers a specific animation sequence:
1. Reset animation state (offset, rotation, scale)
2. Apply category animation using `withAnimation`
3. Schedule reset after animation completes
4. Generate new quest during animation

#### Data Flow
```
User Action → ViewModel Method → Update Published Properties → SwiftUI Re-renders View
```

### Challenges & Solutions

**Challenge**: Xcode project file corruption during initial setup
- **Solution**: Manually recreated `.pbxproj` file, learned Xcode project structure

**Challenge**: Missing `@main` entry point causing build failures
- **Solution**: Created `sidequestApp.swift` with `@main` attribute and `WindowGroup`

**Challenge**: iOS-specific APIs not available on macOS
- **Solution**: Removed `.navigationBarHidden()` (iOS-only modifier)

**Challenge**: Auto-generating new quest after completion
- **Solution**: Chained `DispatchQueue.asyncAfter` calls to sequence animations

---

## Web Version (GitHub Pages)

### Tech Stack
- **HTML5** for structure
- **CSS3** for retro arcade styling
- **Vanilla JavaScript** (ES6+) for logic
- **LocalStorage** for data persistence

### Features
- Same retro arcade aesthetic as iOS app
- Responsive design (mobile-friendly)
- CSS animations matching iOS animations
- LocalStorage for quest history
- No dependencies, works offline after first load

### Deployment
The web version is deployed on GitHub Pages at `/web/`:
- `index.html` - Main HTML structure
- `styles.css` - Retro arcade CSS styling
- `script.js` - Quest logic and animations

To deploy:
1. Push `web/` folder to GitHub
2. Enable GitHub Pages in repo settings
3. Set source to `/web` folder
4. Access at `https://[username].github.io/sidequest/`

---

## Future Enhancements

- **Settings View**: Toggle categories, notification preferences
- **Streak Counter**: Track consecutive days (with arcade score multiplier aesthetic)
- **Custom Quests**: User-defined challenges
- **Difficulty Levels**: Easy/Normal/Hard/Extreme (styled as game modes)
- **Widget Support**: iOS home screen widget with pixel art
- **8-bit Sound Effects**: Retro completion sounds
- **SwiftData Migration**: Replace UserDefaults for better performance
- **Share Feature**: Screenshot completed quests with retro aesthetic

---

## Lessons Learned

1. **Start Simple**: Began with MVP (basic quest generation), added features incrementally
2. **SwiftUI is Declarative**: Think in terms of "what the UI should look like" not "how to update it"
3. **Animations Add Polish**: Small details (category animations) make the app feel alive
4. **Data Persistence is Key**: Users expect their progress to be saved
5. **Color Psychology**: Different colors for categories help with recognition
6. **Retro Aesthetic Works**: High-contrast, pixel-style design is both functional and fun
7. **Test on Device**: Simulator doesn't show true performance/feel
8. **Git Hygiene**: Regular commits with clear messages help track progress

---

## Resources Used

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- SF Symbols for icons
- Retro color palettes: CGA, Game Boy, NES

---

Built with ❤️ while learning Swift and SwiftUI
