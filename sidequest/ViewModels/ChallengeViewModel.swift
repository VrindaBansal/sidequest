import Foundation
import SwiftUI

class ChallengeViewModel: ObservableObject {
    @Published var currentChallenge: Challenge?
    @Published var completedChallenges: [Challenge] = []

    @AppStorage("lastChallengeDate") private var lastChallengeDateString: String = ""
    @AppStorage("enabledCategories") private var enabledCategoriesString: String = ""

    private let generator = ChallengeGenerator.shared

    init() {
        loadData()
        checkForNewChallenge()
    }

    func checkForNewChallenge() {
        let lastDate = ISO8601DateFormatter().date(from: lastChallengeDateString)

        if generator.shouldGenerateNewChallenge(lastDate: lastDate) {
            generateNewChallenge()
        }
    }

    func generateNewChallenge() {
        let enabledCategories = getEnabledCategories()
        currentChallenge = generator.generateDailyChallenge(enabledCategories: enabledCategories)

        if let challenge = currentChallenge {
            lastChallengeDateString = ISO8601DateFormatter().string(from: challenge.date)
            saveData()
        }
    }

    func completeChallenge() {
        guard var challenge = currentChallenge else { return }

        challenge.isCompleted = true
        currentChallenge = challenge
        completedChallenges.append(challenge)
        saveData()
    }

    private func getEnabledCategories() -> Set<ChallengeCategory> {
        if enabledCategoriesString.isEmpty {
            return Set(ChallengeCategory.allCases)
        }

        let categoryStrings = enabledCategoriesString.components(separatedBy: ",")
        let categories = categoryStrings.compactMap { ChallengeCategory(rawValue: $0) }
        return Set(categories)
    }

    private func loadData() {
        // Load completed challenges from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "completedChallenges"),
           let decoded = try? JSONDecoder().decode([Challenge].self, from: data) {
            completedChallenges = decoded
        }

        // Load current challenge if it's from today
        if let data = UserDefaults.standard.data(forKey: "currentChallenge"),
           let decoded = try? JSONDecoder().decode(Challenge.self, from: data),
           Calendar.current.isDateInToday(decoded.date) {
            currentChallenge = decoded
        }
    }

    private func saveData() {
        // Save current challenge
        if let challenge = currentChallenge,
           let encoded = try? JSONEncoder().encode(challenge) {
            UserDefaults.standard.set(encoded, forKey: "currentChallenge")
        }

        // Save completed challenges
        if let encoded = try? JSONEncoder().encode(completedChallenges) {
            UserDefaults.standard.set(encoded, forKey: "completedChallenges")
        }
    }
}
