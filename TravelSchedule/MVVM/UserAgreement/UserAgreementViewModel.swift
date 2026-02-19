//
//  UserAgreementViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 19.02.2026.
//

import Foundation

private enum Constants {
    static let agreementURLString: String = "https://yandex.ru/legal/practicum_offer"
}

@MainActor
final class UserAgreementViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = true

    var agreementURL: URL? {
        URL(string: Constants.agreementURLString)
    }

    func onUpdateLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
}
