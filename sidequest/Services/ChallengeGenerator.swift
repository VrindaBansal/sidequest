import Foundation

class ChallengeGenerator {
    static let shared = ChallengeGenerator()

    private let challenges: [ChallengeCategory: [String]] = [
        .social: [
            "Text an old friend",
            "Call a family member",
            "Compliment a stranger",
            "Have a conversation without checking your phone",
            "Introduce yourself to someone new"
        ],
        .creative: [
            "Draw something for 10 minutes",
            "Write a haiku",
            "Take an artistic photo",
            "Doodle in a notebook",
            "Create something with your hands"
        ],
        .wellness: [
            "Meditate for 5 minutes",
            "Drink 8 glasses of water",
            "Take a walk outside",
            "Stretch for 10 minutes",
            "Go to bed 30 minutes early"
        ],
        .adventure: [
            "Try a new food",
            "Take a different route home",
            "Visit somewhere new in your city",
            "Order something you've never tried",
            "Explore a new neighborhood"
        ],
        .learning: [
            "Learn 3 words in a new language",
            "Read about something random on Wikipedia",
            "Watch a documentary",
            "Listen to a podcast on a new topic",
            "Research something you're curious about"
        ],
        .kindness: [
            "Do something nice for someone",
            "Leave a positive review",
            "Pick up litter you see",
            "Thank someone who helped you",
            "Pay for someone's coffee"
        ]
    ]

    func generateDailyChallenge(enabledCategories: Set<ChallengeCategory> = Set(ChallengeCategory.allCases)) -> Challenge {
        // Filter challenges by enabled categories
        let availableCategories = Array(enabledCategories)

        guard !availableCategories.isEmpty,
              let randomCategory = availableCategories.randomElement(),
              let categoryChallenges = challenges[randomCategory],
              let randomChallenge = categoryChallenges.randomElement() else {
            // Fallback challenge if something goes wrong
            return Challenge(text: "Try something new today", category: .adventure)
        }

        return Challenge(text: randomChallenge, category: randomCategory)
    }

    func shouldGenerateNewChallenge(lastDate: Date?) -> Bool {
        guard let lastDate = lastDate else {
            return true
        }

        let calendar = Calendar.current
        return !calendar.isDateInToday(lastDate)
    }
}
