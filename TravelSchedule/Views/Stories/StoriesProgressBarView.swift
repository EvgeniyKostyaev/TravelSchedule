//
//  StoriesProgressBarView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 15.02.2026.
//

import SwiftUI
import Combine

private enum Layout {
    static let progressBarHorizontalPadding: CGFloat = 12
    static let progressBarHeight: CGFloat = 6
}

struct StoriesProgressBarView: View {
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
        ProgressBarView(numberOfSections: storiesCount, progress: currentProgress)
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

#Preview {
    @Previewable @State var currentProgress: CGFloat = 0.7
    
    Color.purple
        .ignoresSafeArea()
        .overlay {
            StoriesProgressBarView(storiesCount: 7, timerConfiguration: TimerConfiguration(storiesCount: 7), currentProgress: $currentProgress)
        }
}
