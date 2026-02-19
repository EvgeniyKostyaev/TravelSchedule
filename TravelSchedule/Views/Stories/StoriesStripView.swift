//
//  StoriesStripView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 15.02.2026.
//

import SwiftUI

private enum Layout {
    static let stripHeight: CGFloat = 140
    static let stripItemWidth: CGFloat = 92
    static let stripItemSpacing: CGFloat = 12
    static let stripItemCornerRadius: CGFloat = 16
    static let stripHorizontalPadding: CGFloat = 0
    static let stripTrailingInset: CGFloat = 16
    static let stripBorderWidth: CGFloat = 4
    static let stripTitleFontSize: CGFloat = 15
    static let stripTitleBottomPadding: CGFloat = 8
    static let stripTitleHorizontalPadding: CGFloat = 8
    static let stripSeenStoryOpacity: CGFloat = 0.55
    static let stripUnseenStoryOpacity: CGFloat = 1.0
}

struct StoriesStripView: View {
    let stories: [Story]
    let viewedStoryIDs: Set<Int>
    let onTapStory: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Layout.stripItemSpacing) {
                ForEach(Array(stories.enumerated()), id: \.element.id) { index, story in
                    Button {
                        onTapStory(index)
                    } label: {
                        ZStack(alignment: .bottomLeading) {
                            Image(story.previewImageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: Layout.stripItemWidth, height: Layout.stripHeight)
                                .clipped()
                                .opacity(viewedStoryIDs.contains(story.id) ? Layout.stripSeenStoryOpacity : Layout.stripUnseenStoryOpacity)

                            Text(story.title)
                                .font(.system(size: Layout.stripTitleFontSize, weight: .regular))
                                .foregroundStyle(Color.customWhite)
                                .lineLimit(3)
                                .padding(.horizontal, Layout.stripTitleHorizontalPadding)
                                .padding(.bottom, Layout.stripTitleBottomPadding)
                        }
                        .frame(width: Layout.stripItemWidth, height: Layout.stripHeight)
                        .clipShape(RoundedRectangle(cornerRadius: Layout.stripItemCornerRadius, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: Layout.stripItemCornerRadius, style: .continuous)
                                .strokeBorder(
                                    viewedStoryIDs.contains(story.id) ? Color.clear : Color.customBlue,
                                    lineWidth: Layout.stripBorderWidth
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Layout.stripHorizontalPadding)
            .padding(.trailing, Layout.stripTrailingInset)
        }
    }
}

#Preview {
    StoriesStripView(stories: Story.items, viewedStoryIDs: [1], onTapStory: { _ in })
}
