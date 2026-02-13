//
//  StationsListView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 09.02.2026.
//

import SwiftUI

private enum Layout {
    static let backButtonPadding: CGFloat = 8
}

struct StationsListView: View {
    @Environment(\.dismiss) private var dismiss
    
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
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.customBlack)
                }
                .padding(Layout.backButtonPadding)
            }
        }
    }
}

#Preview {
    NavigationStack {
        StationsListView(city: "Москва")
    }
}
