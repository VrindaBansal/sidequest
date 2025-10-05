# Daily Challenge Generator - Product & Tech Spec

## Product Overview

A minimalist iOS app that generates a random daily challenge to encourage users to try new things, step outside their comfort zone, and build positive habits. Each day presents a fresh "sidequest" that can be completed with a satisfying tap and animation.

## Core Philosophy

- **One challenge per day** - Keeps it simple and achievable
- **Low pressure** - Challenges are fun and doable, not stressful
- **Instant gratification** - Satisfying animations when you complete
- **Variety** - Different categories keep it interesting
- **No streaks pressure** - Can skip days without guilt

---

## Features

### MVP (Version 1.0)

#### Daily Challenge
- App generates one random challenge each day at midnight (local time)
- Challenge displays on main screen with clean typography
- Challenge remains the same for the entire day
- New challenge appears automatically the next day

#### Challenge Categories
- **Social**: "Text an old friend", "Compliment a stranger", "Call a family member"
- **Creative**: "Draw something", "Write a haiku", "Take an artistic photo"
- **Wellness**: "Meditate for 5 minutes", "Drink 8 glasses of water", "Take a walk outside"
- **Adventure**: "Try a new food", "Take a different route home", "Visit somewhere new"
- **Learning**: "Learn 3 words in a new language", "Read about something random", "Watch a documentary"
- **Kindness**: "Do something nice for someone", "Leave a positive review", "Pick up litter"

#### Completion
- Large, tappable "Complete" button
- Satisfying animation on completion (confetti, checkmark burst, or glow effect)
- Challenge marks as complete for the day
- Can't be un-completed (commit to it!)

#### History
- Simple list view of past challenges
- Shows date, challenge text, and completion status
- Maybe a completion percentage over time

#### Settings
- Toggle challenge categories on/off
- Notification time preference (optional reminder)
- About/credits page

---

## Technical Specification

### Platform & Tools
- **Language**: Swift
- **Framework**: SwiftUI
- **Minimum iOS Version**: iOS 16.0+
- **Development Tool**: Xcode 15+

### Architecture

#### App Structure
```
DailyChallengeApp/
├── Models/
│   ├── Challenge.swift
│   └── ChallengeCategory.swift
├── Views/
│   ├── MainView.swift
│   ├── HistoryView.swift
│   ├── SettingsView.swift
│   └── Components/
│       ├── ChallengeCard.swift
│       └── CompletionButton.swift
├── ViewModels/
│   └── ChallengeViewModel.swift
├── Services/
│   ├── ChallengeGenerator.swift
│   └── NotificationManager.swift
└── Utilities/
    └── DateHelper.swift
```

### Data Models

#### Challenge
```swift
struct Challenge: Identifiable, Codable {
    let id: UUID
    let text: String
    let category: ChallengeCategory
    let date: Date
    var isCompleted: Bool
}
```

#### ChallengeCategory
```swift
enum ChallengeCategory: String, Codable, CaseIterable {
    case social
    case creative
    case wellness
    case adventure
    case learning
    case kindness
    
    var displayName: String { ... }
    var icon: String { ... } // SF Symbol name
}
```

### Data Persistence

**UserDefaults** (for MVP simplicity)
- Store array of completed challenges
- Store enabled categories
- Store notification preferences
- Store last generated date to prevent multiple generations per day

**Future**: Migrate to SwiftData or Core Data for better performance with larger datasets

### Core Logic

#### Challenge Generation
```swift
class ChallengeGenerator {
    static let challenges: [ChallengeCategory: [String]] = [
        .social: ["Text an old friend", "Call a family member", ...],
        .creative: ["Draw something", "Write a haiku", ...],
        // etc.
    ]
    
    func generateDailyChallenge(enabledCategories: Set<ChallengeCategory>) -> Challenge {
        // Filter by enabled categories
        // Randomly select category
        // Randomly select challenge from that category
        // Return Challenge with today's date
    }
    
    func shouldGenerateNewChallenge(lastDate: Date?) -> Bool {
        // Check if it's a new day
    }
}
```

#### State Management
- Use `@AppStorage` for simple settings
- Use `@StateObject` for ChallengeViewModel in main view
- ViewModel handles business logic and data persistence

### UI/UX Design - Retro Arcade Aesthetic

#### Visual Style
- **Pixel art everything** - chunky pixels, no smooth gradients
- Retro arcade game vibe (think 8-bit or 16-bit era)
- CRT screen effect optional (scanlines, slight glow)
- Vibrant, high-contrast color palette
- Pixel borders and retro UI elements

#### Color Scheme
- Bright arcade colors (neon greens, hot pinks, electric blues)
- Black or dark navy background (like an old arcade cabinet screen)
- Different color schemes per category (each category = different game aesthetic)
- Possibly toggle between classic arcade palettes (CGA, Game Boy green, etc.)

#### Typography
- Pixel/bitmap fonts (custom pixel font or SF Mono for retro feel)
- "Press Start 2P" style font (can use system monospaced with custom styling)
- Text appears with letter-by-letter animation like old RPGs
- Challenge text displayed like dialogue boxes in retro games

#### Pixel Art Elements
- Pixelated icons for each category (sword for adventure, heart for kindness, etc.)
- Pixel art character/mascot that reacts to completion
- Retro UI frames and borders (thick pixel outlines)
- Status indicators as pixel hearts or stars
- Menu buttons styled like arcade cabinet buttons

#### Animations
- **Completion button**: Pixel explosion effect, screen shake
- **Challenge complete**: Coin collect sound + pixel particle burst, score counter animation
- **New challenge**: Slot machine style text reveal or level start animation
- **Screen transitions**: Pixel wipe/dissolve effects like old games
- **Idle state**: Subtle pixel sprite bobbing animation
- **Menu navigation**: Arcade menu select sounds and highlights

#### Sound Design (Optional Enhancement)
- 8-bit blip sounds for button presses
- Retro "level complete" jingle when challenge done
- Coin/power-up sound effects
- Classic arcade menu navigation sounds

#### Layout
- **Main View**: 
  - Pixel art frame around challenge text (like a game dialogue box)
  - Large pixelated "ACTION BUTTON" to complete
  - Score/streak display in corner (arcade score style)
  - Small pixel mascot character in corner
  
- **History View**: 
  - Displayed like an arcade high score screen
  - "MISSION LOG" header in pixel font
  - Each completed challenge = achieved high score entry
  - Checkmarks as pixel sprites
  
- **Settings View**: 
  - Styled like an arcade game options menu
  - Toggle switches as pixel on/off indicators
  - Categories displayed as selectable game modes
  - Retro slider controls for settings

### Notifications (Optional for MVP)

- Local notifications using `UNUserNotificationCenter`
- Daily reminder at user-selected time
- Permission request on first launch or in settings
- Notification content: "Your daily challenge is ready!"

---

## Development Phases

### Phase 1: Core Functionality
- Set up project structure
- Create data models
- Implement challenge generator with hardcoded challenges
- Build basic main view with challenge display
- Add simple completion button (no animation yet)
- Basic data persistence

### Phase 2: Retro UI Foundation
- Design pixel art style system
- Implement pixel borders and frames
- Add retro font/monospaced typography
- Create color palette system for arcade feel
- Basic pixel art icons or placeholders

### Phase 3: Arcade Animations
- Pixel explosion completion effect
- Screen shake on completion
- Text reveal animations (letter-by-letter)
- Transition effects between screens
- Button press feedback (scale, color change)

### Phase 4: History & Settings (Arcade Style)
- Build "high score screen" style history view
- Create arcade game options menu for settings
- Category toggles styled as game mode selectors
- Pixel art checkmarks and status indicators

### Phase 5: Polish & Juice
- Add 8-bit sound effects (optional)
- Implement pixel sprite animations
- Add CRT screen effect (optional)
- Create custom app icon (pixel art)
- Final bug fixes and testing

---

## Future Enhancements (Post-MVP)

- Custom challenges (user can add their own "quests")
- Difficulty levels styled as game modes (Easy/Normal/Hard/Extreme)
- Weekly/monthly "arcade cabinet" style stats screen
- Share completed challenges with retro screenshot aesthetic
- Widget support with pixel art design
- Streak counter displayed as arcade score multiplier
- Friends leaderboard (classic arcade high score style)
- Achievement badges as pixel art medals/trophies
- Challenge history with retro game save file aesthetic
- More challenge categories = more "game cartridges"
- Seasonal pixel art themes (winter, summer, etc.)
- Unlockable pixel art characters/mascots
- Power-up system for extra motivation
- Boss challenge mode (extra hard weekly challenges)
- Retro collectible system (earn pixel items for completing challenges)

---

## Success Metrics

- Daily active users
- Challenge completion rate
- Average challenges completed per week
- Notification opt-in rate
- User retention (7-day, 30-day)

---

## Technical Considerations

### Performance
- Lightweight app, minimal battery usage
- Efficient data storage (UserDefaults sufficient for MVP)
- Smooth 60fps animations

### Accessibility
- VoiceOver support
- Dynamic Type support
- High contrast mode support
- Haptic feedback for completion

### Privacy
- All data stored locally on device
- No analytics or tracking in MVP
- No account required
- No internet connection needed

---

## Estimated Development Time

**Total MVP: Build at your own pace!**

Since you're learning Swift, focus on getting each phase working before moving to the next. The retro aesthetic actually makes this more fun to build because you can see progress quickly - even simple pixel borders make it feel like a real game.

Start with the basic functionality, then slowly add the arcade flavor. The pixel art style is forgiving - chunky and simple beats smooth and complex for this vibe.

---

## Getting Started - Retro Arcade Edition

1. Create new SwiftUI project in Xcode
2. Set up basic navigation structure
3. Create Challenge and ChallengeCategory models
4. Hardcode initial challenge pool (start with 5-10 per category)
5. Build ChallengeGenerator service
6. Create MainView with basic challenge display
7. **Start pixelating!** Add borders, retro colors, chunky buttons
8. Implement pixel fonts (use SF Mono or custom pixel font)
9. Add arcade-style completion animations
10. Keep building and make it feel like a game!

### Pixel Art Resources
- **SF Symbols** can be styled to look more pixelated
- Custom pixel fonts: "Press Start 2P", "VT323", "Pixel Emulator"
- Color inspiration: CGA palette, Game Boy palette, NES palette
- SwiftUI shapes can create pixel-perfect borders and frames
- Particle systems for pixel explosion effects

### Key Retro UI Tips
- Use `.border()` with thick widths for pixel frames
- Monospaced fonts for that retro terminal feel
- High contrast colors (bright on dark)
- Square, chunky buttons with thick borders
- Simple geometric pixel patterns
- Screen shake = offset animation with spring effect

Good luck with your sidequest! 🕹️👾