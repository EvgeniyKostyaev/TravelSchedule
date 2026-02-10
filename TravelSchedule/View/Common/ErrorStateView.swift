//
//  ErrorStateView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 11.02.2026.
//

import SwiftUI

enum ErrorState {
    case noInternet
    case serverError
    
    var image: Image {
        switch self {
        case .noInternet:
            Image(.stateNoInternet)
        case .serverError:
            Image(.stateServerError)
        }
    }
    
    var title: String {
        switch self {
        case .noInternet:
            "Нет интернета"
        case .serverError:
            "Ошибка сервера"
        }
    }
}

struct ErrorStateView: View {
    let errorState: ErrorState
    
    var body: some View {
        VStack(spacing: 16) {
            errorState.image
            Text(errorState.title)
                .foregroundStyle(.customBlack)
                .font(.system(size: 24, weight: .bold))
        }
        .padding()
    }
}

#Preview {
    ErrorStateView(errorState: .noInternet)
}
