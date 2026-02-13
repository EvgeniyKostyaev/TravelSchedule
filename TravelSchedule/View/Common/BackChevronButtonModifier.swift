//
//  BackChevronButtonModifier.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import SwiftUI

private enum Layout {
    static let backButtonPadding: CGFloat = 8
}

private struct BackChevronButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.customBlack)
                    }
                    .padding(Layout.backButtonPadding)
                }
            }
    }
}

extension View {
    func customBackChevronButton() -> some View {
        modifier(BackChevronButtonModifier())
    }
}

