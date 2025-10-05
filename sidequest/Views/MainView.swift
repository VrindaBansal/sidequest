import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = ChallengeViewModel()
    @State private var showCompletionAnimation = false

    var body: some View {
        ZStack {
            // Dark arcade background
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 30) {
                // Title
                Text("SIDEQUEST")
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.green)
                    .padding(.top, 60)

                Spacer()

                // Challenge card
                if let challenge = viewModel.currentChallenge {
                    VStack(spacing: 20) {
                        // Category icon
                        Image(systemName: challenge.category.icon)
                            .font(.system(size: 50))
                            .foregroundColor(.cyan)

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
                            .strokeBorder(Color.green, lineWidth: 4)
                    )
                    .padding(.horizontal, 30)

                    // Complete button
                    if !challenge.isCompleted {
                        Button(action: {
                            completeChallenge()
                        }) {
                            Text("COMPLETE")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.black)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 15)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                    } else {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("COMPLETED!")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.green)
                        }
                        .padding(.top, 20)
                    }
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
    }

    private func completeChallenge() {
        viewModel.completeChallenge()

        // Show animation
        withAnimation(.easeInOut(duration: 0.3)) {
            showCompletionAnimation = true
        }

        // Hide animation after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showCompletionAnimation = false
            }
        }
    }
}

#Preview {
    MainView()
}
