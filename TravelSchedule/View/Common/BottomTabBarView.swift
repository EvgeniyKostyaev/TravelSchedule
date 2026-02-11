//
//  BottomTabBarView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 10.02.2026.
//

import SwiftUI

private enum Layout {
    static let horizontalPadding: CGFloat = 56
    static let iconSize: CGFloat = 30
    static let buttonWidth: CGFloat = 75
    static let buttonHeight: CGFloat = 49
}

struct BottomTabBarView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        VStack(spacing: .zero) {
            Divider()
            HStack {
                tabButton(
                    image: Image(.scheduleTab),
                    tab: .schedule
                )
                
                Spacer()
                
                tabButton(
                    image: Image(.settingsTab),
                    tab: .settings
                )
            }
            .padding(.horizontal, Layout.horizontalPadding)
        }
    }
    
    private func tabButton(image: Image, tab: Tab) -> some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        } label: {
            image
                .renderingMode(.template)
                .foregroundStyle(
                    selectedTab == tab ? .customBlack : .customGray
                )
                .frame(width: Layout.iconSize, height: Layout.iconSize)
        }
        .frame(width: Layout.buttonWidth, height: Layout.buttonHeight)
    }
}

#Preview {
    @Previewable @State var selectedTab: Tab = .schedule
    BottomTabBarView(selectedTab: $selectedTab)
}
