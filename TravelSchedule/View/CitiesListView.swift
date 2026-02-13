//
//  CitiesListView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 09.02.2026.
//

import SwiftUI

struct CitiesListView: View {
    private let onSelect: (String) -> Void
    
    private let cities: [String] = [
        "Москва",
        "Санкт Петербург",
        "Сочи",
        "Горный воздух",
        "Краснодар",
        "Казань",
        "Омск"
    ]
    
    init(onSelect: @escaping (String) -> Void = { _ in }) {
        self.onSelect = onSelect
    }
    
    var body: some View {
        SearchableListView(
            title: "Выбор города",
            placeholder: "Введите запрос",
            emptyTitle: "Город не найден",
            items: cities,
            onSelect: onSelect
        )
    }
}

#Preview {
    NavigationStack {
        CitiesListView()
    }
}
