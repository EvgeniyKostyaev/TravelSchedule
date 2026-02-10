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
    private enum Layout {
        static let stackSpacing: CGFloat = 16
        static let titleFontSize: CGFloat = 24
    }
    
    let errorState: ErrorState
    
    var body: some View {
        VStack(spacing: Layout.stackSpacing) {
            errorState.image
            Text(errorState.title)
                .foregroundStyle(.customBlack)
                .font(.system(size: Layout.titleFontSize, weight: .bold))
        }
        .padding()
    }
}

#Preview {
    ErrorStateView(errorState: .noInternet)
}
