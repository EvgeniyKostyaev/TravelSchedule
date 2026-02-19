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
    static let topPadding: CGFloat = 0
    static let settingsStackSpacing: CGFloat = 0
    static let footerSpacing: CGFloat = 8
    static let footerBottomPadding: CGFloat = 24
    static let subtitleFontSize: CGFloat = 17
    static let footerFontSize: CGFloat = 12
    static let chevronSize: CGFloat = 20
}

struct SettingsView: View {
    @ObservedObject private var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if (viewModel.isLoading && viewModel.copyrightText.isEmpty) {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: Layout.settingsStackSpacing) {
                    Toggle(
                        isOn: Binding(
                            get: { viewModel.isDarkThemeEnabled },
                            set: { isDarkThemeEnabled in
                                viewModel.onUpdateDarkThemeEnabled(isDarkThemeEnabled: isDarkThemeEnabled)
                            }
                        )
                    ) {
                        Text("Темная тема")
                            .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                            .foregroundStyle(Color.customBlack)
                    }
                    .tint(Color.customBlue)
                    .frame(height: Layout.rowHeight)
                    .padding(.horizontal, Layout.horizontalPadding)
                    
                    Button {
                        viewModel.showUserAgreement()
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: Layout.rowHeight)
                        .padding(.horizontal, Layout.horizontalPadding)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    VStack(spacing: Layout.footerSpacing) {
                        Text(!viewModel.copyrightText.isEmpty ? viewModel.copyrightText : "Приложение использует API «Яндекс.Расписания»")
                            .font(.system(size: Layout.footerFontSize, weight: .regular))
                            .foregroundStyle(Color.customBlack)
                        Text("Версия 1.0 (beta)")
                            .font(.system(size: Layout.footerFontSize, weight: .regular))
                            .foregroundStyle(Color.customBlack)
                    }
                    .padding(.bottom, Layout.footerBottomPadding)
                }
                .padding(.top, Layout.topPadding)
                .fullScreenCover(
                    isPresented: Binding(get: { viewModel.isAgreementPresented },
                                         set: { isAgreementPresented in
                                             viewModel.onUpdateAgreementPresented(isAgreementPresented: isAgreementPresented)
                                         })
                ) {
                    NavigationStack {
                        UserAgreementView()
                    }
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
