//
//  StationsListView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 09.02.2026.
//

import SwiftUI

struct StationsListView: View {
    private struct RowHighlightButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.customLightGray.opacity(configuration.isPressed ? 0.6 : 0.0))
                )
                .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
        }
    }
    
    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let searchHeight: CGFloat = 36
        static let searchCornerRadius: CGFloat = 12
        static let searchIconSize: CGFloat = 16
        static let clearButtonSize: CGFloat = 18
        static let searchHorizontalPadding: CGFloat = 12
        static let sectionSpacing: CGFloat = 16
        static let rowSpacing: CGFloat = 24
        static let rowChevronSize: CGFloat = 20
        static let emptyTitleSize: CGFloat = 24
    }
    
    @State private var query: String = ""
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
    
    private var filteredStations: [String] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return stations
        }
        return stations.filter { station in
            station.localizedCaseInsensitiveContains(trimmedQuery)
        }
    }
    
    init(city: String, onSelect: @escaping (String) -> Void = { _ in }) {
        self.city = city
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: Layout.searchIconSize, weight: .regular))
                    .foregroundStyle(Color.customGray)
                
                TextField(
                    "",
                    text: $query,
                    prompt: Text("Введите запрос").foregroundStyle(Color.customGray)
                )
                .foregroundStyle(Color.customBlack)
                .font(.system(size: 17, weight: .regular))
                
                if !query.isEmpty {
                    Button {
                        query = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: Layout.clearButtonSize, weight: .regular))
                            .foregroundStyle(Color.customGray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Layout.searchHorizontalPadding)
            .frame(height: Layout.searchHeight)
            .background(Color.customLightGray)
            .clipShape(
                RoundedRectangle(cornerRadius: Layout.searchCornerRadius, style: .continuous)
            )
            .padding(.horizontal, Layout.horizontalPadding)
            
            if filteredStations.isEmpty {
                Spacer()
                
                Text("Вокзал не найден")
                    .font(.system(size: Layout.emptyTitleSize, weight: .semibold))
                    .foregroundStyle(Color.customBlack)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            } else {
                List {
                    ForEach(filteredStations, id: \.self) { station in
                        Button {
                            onSelect(station)
                        } label: {
                            HStack {
                                Text(station)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.customBlack)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: Layout.rowChevronSize, weight: .semibold))
                                    .foregroundStyle(Color.customBlack)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, Layout.rowSpacing / 2)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(RowHighlightButtonStyle())
                        .listRowInsets(
                            EdgeInsets(
                                top: 0,
                                leading: Layout.horizontalPadding,
                                bottom: 0,
                                trailing: Layout.horizontalPadding
                            )
                        )
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.customWhite)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.customWhite)
            }
        }
        .background(Color.customWhite)
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        StationsListView(city: "Москва")
    }
}
