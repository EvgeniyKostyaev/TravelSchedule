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
    
    private let onSelect: (StationSelectionOption) -> Void

    init(
        city: String,
        onSelect: @escaping (StationSelectionOption) -> Void = { _ in }
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
                    items: viewModel.stations.map(\.title),
                    onSelect: didSelectStation
                )
            }
        }
        .customNavigationBackButton()
        .task {
            await viewModel.load()
        }
    }

    private func didSelectStation(_ stationTitle: String) {
        guard let station = viewModel.stations.first(where: { $0.title == stationTitle }) else {
            return
        }

        onSelect(station)
    }
}

#Preview {
    NavigationStack {
        StationsListView(city: "Москва")
    }
}
