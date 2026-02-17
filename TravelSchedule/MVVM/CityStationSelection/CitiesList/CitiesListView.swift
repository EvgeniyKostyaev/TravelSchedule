//
//  CitiesListView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 09.02.2026.
//

import SwiftUI

@MainActor
struct CitiesListView: View {
    @StateObject private var viewModel: CitiesListViewModel = CitiesListViewModel()
    
    private let onSelect: (String) -> Void
    
    init(onSelect: @escaping (String) -> Void = { _ in }) {
        self.onSelect = onSelect
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.cities.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorKind = viewModel.errorKind, viewModel.cities.isEmpty {
                ErrorStateView(
                    errorState: errorKind == .noInternet ? .noInternet : .serverError
                )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                SearchableListView(
                    title: "Выбор города",
                    placeholder: "Введите запрос",
                    emptyTitle: "Город не найден",
                    items: viewModel.cities,
                    onSelect: onSelect
                )
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        CitiesListView()
    }
}
