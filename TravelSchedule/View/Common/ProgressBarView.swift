//
//  ProgressBarView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 15.02.2026.
//

import SwiftUI

private enum Layout {
    static let progressBarCornerRadius: CGFloat = 6
    static let progressBarHeight: CGFloat = 6

    static let progressAnimationDuration: CGFloat = 0.2
}

struct ProgressBarView: View {
    let numberOfSections: Int
    let progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: Layout.progressBarCornerRadius)
                    .frame(width: geometry.size.width, height: Layout.progressBarHeight)
                    .foregroundColor(.white)

                RoundedRectangle(cornerRadius: Layout.progressBarCornerRadius)
                    .frame(
                        width: min(progress * geometry.size.width, geometry.size.width),
                        height: Layout.progressBarHeight
                    )
                    .foregroundColor(.customBlue)
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
        RoundedRectangle(cornerRadius: Layout.progressBarCornerRadius)
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: Layout.progressBarHeight)
            .foregroundStyle(.white)
    }
}

#Preview {
    Color.purple
        .ignoresSafeArea()
        .overlay {
            ProgressBarView(numberOfSections: 5, progress: 0.5)
        }
}
