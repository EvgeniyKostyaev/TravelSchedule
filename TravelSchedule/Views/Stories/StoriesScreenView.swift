//
//  StoriesScreenView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 15.02.2026.
//

import SwiftUI

private enum Layout {
    static let closeButtonTopPadding: CGFloat = 50
    static let closeButtonTrailingPadding: CGFloat = 12
}

struct StoriesScreenView: View {
    let stories: [Story]
    @Binding var viewedStoryIDs: Set<Int>
    let initialStoryIndex: Int
    let onClose: () -> Void

    @State private var currentStoryIndex: Int

    init(
        stories: [Story],
        viewedStoryIDs: Binding<Set<Int>>,
        initialStoryIndex: Int,
        onClose: @escaping () -> Void
    ) {
        self.stories = stories
        self._viewedStoryIDs = viewedStoryIDs
        self.initialStoryIndex = initialStoryIndex
        self.onClose = onClose
        _currentStoryIndex = State(initialValue: initialStoryIndex)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            StoriesView(
                stories: stories,
                currentStoryIndex: $currentStoryIndex
            )

            CloseButtonView(action: onClose)
                .padding(.top, Layout.closeButtonTopPadding)
                .padding(.trailing, Layout.closeButtonTrailingPadding)
        }
        .onAppear {
            markViewed(index: currentStoryIndex)
        }
        .onChange(of: currentStoryIndex) { _, newValue in
            markViewed(index: newValue)
        }
    }

    private func markViewed(index: Int) {
        guard stories.indices.contains(index) else {
            return
        }
        viewedStoryIDs.insert(stories[index].id)
    }
}

#Preview {
    @Previewable @State var viewedStoryIDs: Set<Int> = [0]
    StoriesScreenView(stories: Story.items, viewedStoryIDs: $viewedStoryIDs, initialStoryIndex: 0, onClose: {})
}
