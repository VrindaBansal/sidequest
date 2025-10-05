import Foundation

enum ChallengeCategory: String, Codable, CaseIterable {
    case social
    case creative
    case wellness
    case adventure
    case learning
    case kindness

    var displayName: String {
        switch self {
        case .social: return "Social"
        case .creative: return "Creative"
        case .wellness: return "Wellness"
        case .adventure: return "Adventure"
        case .learning: return "Learning"
        case .kindness: return "Kindness"
        }
    }

    var icon: String {
        switch self {
        case .social: return "person.2.fill"
        case .creative: return "paintbrush.fill"
        case .wellness: return "heart.fill"
        case .adventure: return "figure.walk"
        case .learning: return "book.fill"
        case .kindness: return "hand.raised.fill"
        }
    }
}
