//
//  CloseButtonView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 15.02.2026.
//

import SwiftUI

private enum Layout {
    static let closeButtonPadding: CGFloat = 10
    static let closeButtonHeight: CGFloat = 30
}

struct CloseButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(.closeButton)
                .padding(Layout.closeButtonPadding)
                .clipShape(Circle())
        }
        .frame(width: Layout.closeButtonHeight, height: Layout.closeButtonHeight)
    }
}

#Preview {
    CloseButtonView(action: { })
}
