import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: ChallengeViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Dark arcade background
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.yellow)
                            .padding()
                    }

                    Spacer()

                    Text("MISSION LOG")
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)

                    Spacer()

                    // Spacer to balance the back button
                    Color.clear
                        .frame(width: 60)
                }
                .padding(.top, 50)

                // Stats
                if !viewModel.completedChallenges.isEmpty {
                    VStack(spacing: 5) {
                        Text("COMPLETED: \(viewModel.completedChallenges.count)")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyan)

                        let percentage = calculateCompletionPercentage()
                        Text("SUCCESS RATE: \(percentage)%")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.yellow)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                }

                // Quest list
                if viewModel.completedChallenges.isEmpty {
                    Spacer()
                    VStack(spacing: 15) {
                        Image(systemName: "questionmark.square.dashed")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)

                        Text("NO QUESTS COMPLETED YET")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.gray)

                        Text("Complete your first quest to see it here!")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.gray.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.completedChallenges.reversed()) { challenge in
                                QuestHistoryCard(challenge: challenge)
                            }
                        }
                        .padding()
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }

    private func calculateCompletionPercentage() -> Int {
        // Simple calculation: completed challenges as percentage
        // You could enhance this by tracking total challenges seen
        let total = viewModel.completedChallenges.count
        let completed = viewModel.completedChallenges.filter { $0.isCompleted }.count
        guard total > 0 else { return 0 }
        return Int((Double(completed) / Double(total)) * 100)
    }
}

struct QuestHistoryCard: View {
    let challenge: Challenge

    var body: some View {
        HStack(spacing: 15) {
            // Category icon
            Image(systemName: challenge.category.icon)
                .font(.system(size: 30))
                .foregroundColor(categoryColor(for: challenge.category))
                .frame(width: 50, height: 50)

            // Challenge info
            VStack(alignment: .leading, spacing: 5) {
                Text(challenge.category.displayName.uppercased())
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.yellow)

                Text(challenge.text)
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
                    .lineLimit(2)

                Text(formatDate(challenge.date))
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.gray)
            }

            Spacer()

            // Completion checkmark
            if challenge.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(categoryColor(for: challenge.category), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.05))
                )
        )
    }

    private func categoryColor(for category: ChallengeCategory) -> Color {
        switch category {
        case .social: return .cyan
        case .creative: return .purple
        case .wellness: return .green
        case .adventure: return .orange
        case .learning: return .blue
        case .kindness: return .pink
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView(viewModel: ChallengeViewModel())
}
