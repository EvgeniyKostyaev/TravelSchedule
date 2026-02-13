//
//  StoriesView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import SwiftUI
import Combine

private enum StoryLayout {
    static let stripHeight: CGFloat = 140
    static let stripItemWidth: CGFloat = 92
    static let stripItemSpacing: CGFloat = 12
    static let stripItemCornerRadius: CGFloat = 16
    static let stripHorizontalPadding: CGFloat = 0
    static let stripBorderWidth: CGFloat = 4
    static let stripTitleFontSize: CGFloat = 15
    static let stripTitleBottomPadding: CGFloat = 8
    static let stripTitleHorizontalPadding: CGFloat = 8

    static let closeButtonTopPadding: CGFloat = 57
    static let closeButtonTrailingPadding: CGFloat = 12
    static let closeButtonIconSize: CGFloat = 20
    static let closeButtonPadding: CGFloat = 10

    static let fullStoryTitleFontSize: CGFloat = 34
    static let fullStoryDescriptionFontSize: CGFloat = 20
    static let fullStoryBottomPadding: CGFloat = 40
    static let fullStoryHorizontalPadding: CGFloat = 16
    static let fullStoryTextSpacing: CGFloat = 10

    static let progressBarTopPadding: CGFloat = 28
    static let progressBarHorizontalPadding: CGFloat = 12
    static let progressBarBottomPadding: CGFloat = 12

    static let progressBarCornerRadius: CGFloat = 6
    static let progressBarHeight: CGFloat = 6

    static let progressAnimationDuration: CGFloat = 0.2
    static let seenStoryOpacity: CGFloat = 0.55
    static let unseenStoryOpacity: CGFloat = 1.0
}

struct Story: Identifiable, Hashable {
    let id: Int
    let previewImageName: String
    let fullImageName: String
    let title: String
    let description: String

    static let items: [Story] = [
        Story(
            id: 0,
            previewImageName: "Illustration_preview_1",
            fullImageName: "Illustration_1",
            title: "История 1",
            description: "Подборка направлений и маршрутов для путешествий"
        ),
        Story(
            id: 1,
            previewImageName: "Illustration_preview_3",
            fullImageName: "Illustration_3",
            title: "История 2",
            description: "Лучшие варианты поездок на ближайшие даты"
        ),
        Story(
            id: 2,
            previewImageName: "Illustration_preview_5",
            fullImageName: "Illustration_5",
            title: "История 3",
            description: "Планируйте пересадки и время отправления заранее"
        ),
        Story(
            id: 3,
            previewImageName: "Illustration_preview_9",
            fullImageName: "Illustration_9",
            title: "История 4",
            description: "Выбирайте перевозчика и фильтруйте результаты поиска"
        ),
        Story(
            id: 4,
            previewImageName: "Illustration_preview_17",
            fullImageName: "Illustration_17",
            title: "История 5",
            description: "Сохраните удобный маршрут и возвращайтесь к нему позже"
        )
    ]
}

struct TimerConfiguration {
    let storiesCount: Int
    let timerTickInterval: TimeInterval
    let progressPerTick: CGFloat

    init(
        storiesCount: Int,
        secondsPerStory: TimeInterval = 5,
        timerTickInterval: TimeInterval = 0.05
    ) {
        self.storiesCount = storiesCount
        self.timerTickInterval = timerTickInterval
        self.progressPerTick = 1.0 / CGFloat(storiesCount) / secondsPerStory * timerTickInterval
    }

    func progress(for storyIndex: Int) -> CGFloat {
        min(CGFloat(storyIndex) / CGFloat(storiesCount), 1)
    }

    func index(for progress: CGFloat) -> Int {
        min(Int(progress * CGFloat(storiesCount)), storiesCount - 1)
    }

    func nextProgress(progress: CGFloat) -> CGFloat {
        min(progress + progressPerTick, 1)
    }
}

struct StoriesStripView: View {
    let stories: [Story]
    let viewedStoryIDs: Set<Int>
    let onTapStory: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: StoryLayout.stripItemSpacing) {
                ForEach(Array(stories.enumerated()), id: \.element.id) { index, story in
                    Button {
                        onTapStory(index)
                    } label: {
                        ZStack(alignment: .bottomLeading) {
                            Image(story.previewImageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: StoryLayout.stripItemWidth, height: StoryLayout.stripHeight)
                                .clipped()
                                .opacity(viewedStoryIDs.contains(story.id) ? StoryLayout.seenStoryOpacity : StoryLayout.unseenStoryOpacity)

                            Text(story.title)
                                .font(.system(size: StoryLayout.stripTitleFontSize, weight: .regular))
                                .foregroundStyle(Color.customWhite)
                                .lineLimit(3)
                                .padding(.horizontal, StoryLayout.stripTitleHorizontalPadding)
                                .padding(.bottom, StoryLayout.stripTitleBottomPadding)
                        }
                        .frame(width: StoryLayout.stripItemWidth, height: StoryLayout.stripHeight)
                        .clipShape(RoundedRectangle(cornerRadius: StoryLayout.stripItemCornerRadius, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: StoryLayout.stripItemCornerRadius, style: .continuous)
                                .stroke(
                                    viewedStoryIDs.contains(story.id) ? Color.clear : Color.customBlue,
                                    lineWidth: StoryLayout.stripBorderWidth
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, StoryLayout.stripHorizontalPadding)
        }
    }
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

            CloseButton(action: onClose)
                .padding(.top, StoryLayout.closeButtonTopPadding)
                .padding(.trailing, StoryLayout.closeButtonTrailingPadding)
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

            StoriesProgressBar(
                storiesCount: stories.count,
                timerConfiguration: timerConfiguration,
                currentProgress: $currentProgress
            )
            .padding(
                EdgeInsets(
                    top: StoryLayout.progressBarTopPadding,
                    leading: StoryLayout.progressBarHorizontalPadding,
                    bottom: StoryLayout.progressBarBottomPadding,
                    trailing: StoryLayout.progressBarHorizontalPadding
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
        withAnimation(.easeInOut(duration: StoryLayout.progressAnimationDuration)) {
            currentProgress = progress
        }
    }

    private func didChangeCurrentProgress(newProgress: CGFloat) {
        let index = timerConfiguration.index(for: newProgress)
        guard index != currentStoryIndex else {
            return
        }
        withAnimation(.easeInOut(duration: StoryLayout.progressAnimationDuration)) {
            currentStoryIndex = index
        }
    }
}

struct StoriesProgressBar: View {
    let storiesCount: Int
    let timerConfiguration: TimerConfiguration
    @Binding var currentProgress: CGFloat

    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?

    init(storiesCount: Int, timerConfiguration: TimerConfiguration, currentProgress: Binding<CGFloat>) {
        self.storiesCount = storiesCount
        self.timerConfiguration = timerConfiguration
        _currentProgress = currentProgress
        _timer = State(initialValue: Self.makeTimer(configuration: timerConfiguration))
    }

    var body: some View {
        ProgressBar(numberOfSections: storiesCount, progress: currentProgress)
            .padding(
                EdgeInsets(
                    top: StoryLayout.progressBarHeight,
                    leading: StoryLayout.progressBarHorizontalPadding,
                    bottom: StoryLayout.progressBarHorizontalPadding,
                    trailing: StoryLayout.progressBarHorizontalPadding
                )
            )
            .onAppear {
                timer = Self.makeTimer(configuration: timerConfiguration)
                cancellable = timer.connect()
            }
            .onDisappear {
                cancellable?.cancel()
            }
            .onReceive(timer) { _ in
                timerTick()
            }
    }

    private func timerTick() {
        withAnimation(.linear(duration: timerConfiguration.timerTickInterval)) {
            currentProgress = timerConfiguration.nextProgress(progress: currentProgress)
        }
    }

    private static func makeTimer(configuration: TimerConfiguration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerTickInterval, on: .main, in: .common)
    }
}

struct StoriesTabView: View {
    let stories: [Story]
    @Binding var currentStoryIndex: Int

    var body: some View {
        TabView(selection: $currentStoryIndex) {
            ForEach(Array(stories.enumerated()), id: \.element.id) { index, story in
                StoryPageView(story: story)
                    .tag(index)
                    .onTapGesture {
                        didTapStory()
                    }
            }
        }
        .ignoresSafeArea()
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }

    private func didTapStory() {
        currentStoryIndex = min(currentStoryIndex + 1, stories.count - 1)
    }
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
                    VStack(alignment: .leading, spacing: StoryLayout.fullStoryTextSpacing) {
                        Text(story.title)
                            .font(.system(size: StoryLayout.fullStoryTitleFontSize, weight: .bold))
                            .foregroundColor(.white)
                        Text(story.description)
                            .font(.system(size: StoryLayout.fullStoryDescriptionFontSize, weight: .regular))
                            .lineLimit(3)
                            .foregroundColor(.white)
                    }
                    .padding(
                        EdgeInsets(
                            top: 0,
                            leading: StoryLayout.fullStoryHorizontalPadding,
                            bottom: StoryLayout.fullStoryBottomPadding,
                            trailing: StoryLayout.fullStoryHorizontalPadding
                        )
                    )
                }
            )
    }
}

struct CloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: StoryLayout.closeButtonIconSize, weight: .semibold))
                .foregroundStyle(Color.customBlack)
                .padding(StoryLayout.closeButtonPadding)
                .background(Color.customWhite.opacity(0.9))
                .clipShape(Circle())
        }
    }
}

struct ProgressBar: View {
    let numberOfSections: Int
    let progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: StoryLayout.progressBarCornerRadius)
                    .frame(width: geometry.size.width, height: StoryLayout.progressBarHeight)
                    .foregroundColor(.white.opacity(0.35))

                RoundedRectangle(cornerRadius: StoryLayout.progressBarCornerRadius)
                    .frame(
                        width: min(progress * geometry.size.width, geometry.size.width),
                        height: StoryLayout.progressBarHeight
                    )
                    .foregroundColor(.white)
            }
            .mask {
                MaskView(numberOfSections: numberOfSections)
            }
        }
    }
}

private struct MaskView: View {
    let numberOfSections: Int

    var body: some View {
        HStack {
            ForEach(0..<numberOfSections, id: \.self) { _ in
                MaskFragmentView()
            }
        }
    }
}

private struct MaskFragmentView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: StoryLayout.progressBarCornerRadius)
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: StoryLayout.progressBarHeight)
            .foregroundStyle(.white)
    }
}

#Preview {
    StoriesScreenView(
        stories: Story.items,
        viewedStoryIDs: .constant([]),
        initialStoryIndex: 0,
        onClose: {}
    )
}
