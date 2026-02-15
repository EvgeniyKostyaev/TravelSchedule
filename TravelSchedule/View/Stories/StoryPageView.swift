//
//  StoryPageView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 15.02.2026.
//

import SwiftUI

private enum Layout {
    static let fullStoryTitleFontSize: CGFloat = 34
    static let fullStoryDescriptionFontSize: CGFloat = 20
    static let fullStoryBottomPadding: CGFloat = 40
    static let fullStoryTextSpacing: CGFloat = 16
    static let fullStoryTitleTextLineLimit: Int = 2
    static let fullStoryDescriptionTextLineLimit: Int = 3
}

struct StoryPageView: View {
    let story: Story
    
    var body: some View {
        Image(story.fullImageName)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: Layout.fullStoryTextSpacing) {
                        Text(story.title)
                            .font(.system(size: Layout.fullStoryTitleFontSize, weight: .bold))
                            .lineLimit(Layout.fullStoryTitleTextLineLimit)
                            .foregroundColor(.white)
                        Text(story.description)
                            .font(.system(size: Layout.fullStoryDescriptionFontSize, weight: .regular))
                            .lineLimit(Layout.fullStoryDescriptionTextLineLimit)
                            .foregroundColor(.white)
                    }
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, Layout.fullStoryBottomPadding)
            )
    }
}

#Preview {
    StoryPageView(story: Story.items[0])
}
