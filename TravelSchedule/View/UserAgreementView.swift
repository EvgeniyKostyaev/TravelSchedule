//
//  UserAgreementView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import SwiftUI

private enum Layout {
    static let agreementURLString: String = "https://yandex.ru/legal/practicum_offer"
}

struct UserAgreementView: View {
    @State private var isLoading: Bool = true
    
    private var agreementURL: URL? {
        URL(string: Layout.agreementURLString)
    }
    
    var body: some View {
        ZStack {
            Group {
                if let url = agreementURL {
                    WebView(url: url, isLoading: $isLoading)
                } else {
                    ErrorStateView(errorState: .serverError)
                }
            }
            
            if agreementURL != nil && isLoading {
                ProgressView()
            }
        }
        .customBackChevronButton()
        .navigationTitle("Пользовательское соглашение")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        UserAgreementView()
    }
}
