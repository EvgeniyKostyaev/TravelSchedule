//
//  StationsListView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 09.02.2026.
//

import SwiftUI

@MainActor
struct StationsListView: View {
    @StateObject private var viewModel: StationsListViewModel
    
    private let onSelect: (String) -> Void

    init(
        city: String,
        onSelect: @escaping (String) -> Void = { _ in }
    ) {
        _viewModel = StateObject(wrappedValue: StationsListViewModel(city: city))
        self.onSelect = onSelect
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.stations.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorKind = viewModel.errorKind, viewModel.stations.isEmpty {
                ErrorStateView(
                    errorState: errorKind == .noInternet ? .noInternet : .serverError
                )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                SearchableListView(
                    title: "Выбор станции",
                    placeholder: "Введите запрос",
                    emptyTitle: "Вокзал не найден",
                    items: viewModel.stations,
                    onSelect: onSelect
                )
            }
        }
        .customNavigationBackButton()
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        StationsListView(city: "Москва")
    }
}
