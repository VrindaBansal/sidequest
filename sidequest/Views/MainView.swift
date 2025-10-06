import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = ChallengeViewModel()
    @State private var showCompletionAnimation = false
    @State private var showNewQuestAnimation = false
    @State private var animationOffset: CGFloat = 0
    @State private var animationRotation: Double = 0
    @State private var animationScale: CGFloat = 1.0
    @State private var showHistory = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Dark arcade background
                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    // Header with title and history button
                    HStack {
                        Spacer()

                        Text("SIDEQUEST")
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                            .foregroundColor(.green)

                        Spacer()

                        // History button
                        Button(action: {
                            showHistory = true
                        }) {
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 24))
                                .foregroundColor(.yellow)
                                .padding()
                        }
                    }
                    .padding(.top, 60)
                    .padding(.trailing, 10)

                    Spacer()

                    // Challenge card
                    if let challenge = viewModel.currentChallenge {
                        VStack(spacing: 20) {
                            // Category icon with animation
                            Image(systemName: challenge.category.icon)
                                .font(.system(size: 50))
                                .foregroundColor(categoryColor(for: challenge.category))
                                .offset(y: animationOffset)
                                .rotationEffect(.degrees(animationRotation))
                                .scaleEffect(animationScale)

                            // Challenge text
                            Text(challenge.text)
                                .font(.system(size: 24, weight: .semibold, design: .monospaced))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)

                            // Category name
                            Text(challenge.category.displayName.uppercased())
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.yellow)
                        }
                        .padding(40)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(categoryColor(for: challenge.category), lineWidth: 4)
                        )
                        .padding(.horizontal, 30)

                        // Buttons
                        HStack(spacing: 20) {
                            // New Quest button
                            Button(action: {
                                getNewQuest()
                            }) {
                                Text("NEW QUEST")
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 12)
                                    .background(Color.yellow)
                                    .cornerRadius(8)
                            }

                            // Complete button
                            if !challenge.isCompleted {
                                Button(action: {
                                    completeChallenge()
                                }) {
                                    Text("COMPLETE")
                                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 12)
                                        .background(Color.green)
                                        .cornerRadius(8)
                                }
                            } else {
                                HStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("DONE!")
                                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .padding(.top, 20)
                    } else {
                        Text("Loading challenge...")
                            .font(.system(size: 18, design: .monospaced))
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }

                // Completion animation overlay
                if showCompletionAnimation {
                    Color.green.opacity(0.3)
                        .ignoresSafeArea()
                        .transition(.opacity)
                }
            }
            .onAppear {
                viewModel.checkForNewChallenge()
            }
            .sheet(isPresented: $showHistory) {
                HistoryView(viewModel: viewModel)
            }
        }
    }

    private func completeChallenge() {
        viewModel.completeChallenge()

        // Show animation
        withAnimation(.easeInOut(duration: 0.3)) {
            showCompletionAnimation = true
        }

        // Hide animation and show new quest
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showCompletionAnimation = false
            }

            // Get new quest after completion animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                getNewQuest()
            }
        }
    }

    private func getNewQuest() {
        guard let category = viewModel.currentChallenge?.category else { return }

        // Trigger category-specific animation
        playCategoryAnimation(for: category)

        // Generate new challenge after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            viewModel.generateNewChallenge()
        }
    }

    private func playCategoryAnimation(for category: ChallengeCategory) {
        // Reset animations
        animationOffset = 0
        animationRotation = 0
        animationScale = 1.0

        switch category {
        case .social:
            // Bounce animation
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                animationOffset = -20
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    animationOffset = 0
                }
            }

        case .creative:
            // Spin animation
            withAnimation(.easeInOut(duration: 0.6)) {
                animationRotation = 360
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                animationRotation = 0
            }

        case .wellness:
            // Pulse animation
            withAnimation(.easeInOut(duration: 0.3)) {
                animationScale = 1.3
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    animationScale = 1.0
                }
            }

        case .adventure:
            // Shake animation
            for i in 0..<6 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                    withAnimation(.linear(duration: 0.1)) {
                        animationOffset = i % 2 == 0 ? 10 : -10
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                animationOffset = 0
            }

        case .learning:
            // Fade and scale
            withAnimation(.easeOut(duration: 0.3)) {
                animationScale = 0.7
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeIn(duration: 0.3)) {
                    animationScale = 1.0
                }
            }

        case .kindness:
            // Float up and down
            withAnimation(.easeInOut(duration: 0.3)) {
                animationOffset = -15
                animationScale = 1.1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    animationOffset = 0
                    animationScale = 1.0
                }
            }
        }
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
}

#Preview {
    MainView()
}
