//
//  StationsListView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 09.02.2026.
//

import SwiftUI

struct StationsListView: View {
    private let city: String
    private let onSelect: (String) -> Void
    
    private let stationsByCity: [String: [String]] = [
        "Москва": [
            "Киевский вокзал",
            "Курский вокзал",
            "Ярославский вокзал",
            "Белорусский вокзал",
            "Савеловский вокзал",
            "Ленинградский вокзал"
        ],
        "Санкт Петербург": [
            "Московский вокзал",
            "Ладожский вокзал",
            "Финляндский вокзал",
            "Витебский вокзал",
            "Балтийский вокзал"
        ],
        "Сочи": ["Сочи"],
        "Горный воздух": ["Горный воздух"],
        "Краснодар": ["Краснодар-1", "Краснодар-2"],
        "Казань": ["Казань-Пассажирская"],
        "Омск": ["Омск-Пассажирский"]
    ]
    
    private var stations: [String] {
        stationsByCity[city] ?? []
    }
    
    init(city: String, onSelect: @escaping (String) -> Void = { _ in }) {
        self.city = city
        self.onSelect = onSelect
    }
    
    var body: some View {
        SearchableListView(
            title: "Выбор станции",
            placeholder: "Введите запрос",
            emptyTitle: "Вокзал не найден",
            items: stations,
            onSelect: onSelect
        )
        .customNavigationBackButton()
    }
}

#Preview {
    NavigationStack {
        StationsListView(city: "Москва")
    }
}
