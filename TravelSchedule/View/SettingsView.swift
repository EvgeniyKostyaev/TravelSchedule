//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 10.02.2026.
//

import SwiftUI

private enum Layout {
    static let rowHeight: CGFloat = 60
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 24
    static let settingsStackSpacing: CGFloat = 0
    static let footerSpacing: CGFloat = 8
    static let footerBottomPadding: CGFloat = 24
    static let subtitleFontSize: CGFloat = 17
    static let footerFontSize: CGFloat = 12
    static let chevronSize: CGFloat = 20
}

struct SettingsView: View {
    @Binding var isDarkThemeEnabled: Bool
    @State private var isAgreementPresented: Bool = false

    var body: some View {
        VStack(spacing: Layout.settingsStackSpacing) {
            Toggle(isOn: $isDarkThemeEnabled) {
                Text("Темная тема")
                    .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                    .foregroundStyle(Color.customBlack)
            }
            .tint(Color.customBlue)
            .frame(height: Layout.rowHeight)
            .padding(.horizontal, Layout.horizontalPadding)

            Divider()

            Button {
                isAgreementPresented = true
            } label: {
                HStack {
                    Text("Пользовательское соглашение")
                        .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                        .foregroundStyle(Color.customBlack)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: Layout.chevronSize, weight: .semibold))
                        .foregroundStyle(Color.customBlack)
                }
                .frame(height: Layout.rowHeight)
                .padding(.horizontal, Layout.horizontalPadding)
            }
            .buttonStyle(.plain)

            Divider()

            Spacer()

            VStack(spacing: Layout.footerSpacing) {
                Text("Приложение использует API «Яндекс.Расписания»")
                    .font(.system(size: Layout.footerFontSize, weight: .regular))
                    .foregroundStyle(Color.customGray)
                Text("Версия 1.0 (beta)")
                    .font(.system(size: Layout.footerFontSize, weight: .regular))
                    .foregroundStyle(Color.customGray)
            }
            .padding(.bottom, Layout.footerBottomPadding)
        }
        .padding(.top, Layout.topPadding)
        .fullScreenCover(isPresented: $isAgreementPresented) {
            NavigationStack {
                UserAgreementView()
            }
        }
    }
}

#Preview {
    SettingsView(isDarkThemeEnabled: .constant(false))
}
