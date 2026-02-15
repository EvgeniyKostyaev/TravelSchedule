//
//  StoriesView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import SwiftUI
import Combine

private enum Layout {
    static let progressBarTopPadding: CGFloat = 28
    static let progressBarHorizontalPadding: CGFloat = 12
    static let progressBarBottomPadding: CGFloat = 12
    static let progressAnimationDuration: CGFloat = 0.2
}

struct StoriesView: View {
    let stories: [Story]
    @Binding var currentStoryIndex: Int

    private var timerConfiguration: TimerConfiguration {
        .init(storiesCount: stories.count)
    }

    @State private var currentProgress: CGFloat = 0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            StoriesTabView(stories: stories, currentStoryIndex: $currentStoryIndex)
                .onChange(of: currentStoryIndex) { oldValue, newValue in
                    didChangeCurrentIndex(oldIndex: oldValue, newIndex: newValue)
                }

            StoriesProgressBarView(
                storiesCount: stories.count,
                timerConfiguration: timerConfiguration,
                currentProgress: $currentProgress
            )
            .padding(
                EdgeInsets(
                    top: Layout.progressBarTopPadding,
                    leading: Layout.progressBarHorizontalPadding,
                    bottom: Layout.progressBarBottomPadding,
                    trailing: Layout.progressBarHorizontalPadding
                )
            )
            .onChange(of: currentProgress) { _, newValue in
                didChangeCurrentProgress(newProgress: newValue)
            }
        }
        .onAppear {
            currentProgress = timerConfiguration.progress(for: currentStoryIndex)
        }
    }

    private func didChangeCurrentIndex(oldIndex: Int, newIndex: Int) {
        guard oldIndex != newIndex else {
            return
        }
        let progress = timerConfiguration.progress(for: newIndex)
        guard abs(progress - currentProgress) >= 0.01 else {
            return
        }
        withAnimation(.easeInOut(duration: Layout.progressAnimationDuration)) {
            currentProgress = progress
        }
    }

    private func didChangeCurrentProgress(newProgress: CGFloat) {
        let index = timerConfiguration.index(for: newProgress)
        guard index != currentStoryIndex else {
            return
        }
        withAnimation(.easeInOut(duration: Layout.progressAnimationDuration)) {
            currentStoryIndex = index
        }
    }
}

#Preview {
    @Previewable @State var currentStoryIndex: Int = 0
    StoriesView(stories: Story.items, currentStoryIndex: $currentStoryIndex)
}
