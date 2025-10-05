import Foundation

struct Challenge: Identifiable, Codable {
    let id: UUID
    let text: String
    let category: ChallengeCategory
    let date: Date
    var isCompleted: Bool

    init(id: UUID = UUID(), text: String, category: ChallengeCategory, date: Date = Date(), isCompleted: Bool = false) {
        self.id = id
        self.text = text
        self.category = category
        self.date = date
        self.isCompleted = isCompleted
    }
}
