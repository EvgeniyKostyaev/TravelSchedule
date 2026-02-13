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
    var body: some View {
        Group {
            if let url = URL(string: Layout.agreementURLString) {
                WebView(url: url)
            } else {
                ErrorStateView(errorState: .serverError)
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
