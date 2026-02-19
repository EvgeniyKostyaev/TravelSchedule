//
//  UserAgreementView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import SwiftUI

struct UserAgreementView: View {
    @StateObject private var viewModel: UserAgreementViewModel = UserAgreementViewModel()
    
    var body: some View {
        ZStack {
            Group {
                if let url = viewModel.agreementURL {
                    WebView(
                        url: url,
                        isLoading: Binding(
                            get: { viewModel.isLoading },
                            set: { isLoading in
                                viewModel.onUpdateLoading(isLoading)
                            }
                        )
                    )
                } else {
                    ErrorStateView(errorState: .serverError)
                }
            }
            
            if viewModel.agreementURL != nil && viewModel.isLoading {
                ProgressView()
            }
        }
        .customNavigationBackButton()
        .navigationTitle("Пользовательское соглашение")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        UserAgreementView()
    }
}
