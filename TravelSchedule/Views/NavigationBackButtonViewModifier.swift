//
//  NavigationBackButtonView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import SwiftUI

private enum Layout {
    static let backButtonPadding: CGFloat = 8
}

/// Полностью заменяет системную кнопку "Назад"
/// и вручную добавляет кастомную кнопку с dismiss()
private struct NavigationBackButtonViewModifier: ViewModifier {
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
    func customNavigationBackButton() -> some View {
        modifier(NavigationBackButtonViewModifier())
    }
}

