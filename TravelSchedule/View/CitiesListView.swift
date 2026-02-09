//
//  CitiesListView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 09.02.2026.
//

import SwiftUI

struct CitiesListView: View {
    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 12
        static let titleFontSize: CGFloat = 17
        static let backButtonSize: CGFloat = 24
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
    @Environment(\.dismiss) private var dismiss
    private let onSelect: (String) -> Void
    
    private let cities: [String] = [
        "Москва",
        "Санкт Петербург",
        "Сочи",
        "Горный воздух",
        "Краснодар",
        "Казань",
        "Омск",
        "Москва",
        "Санкт Петербург",
        "Сочи",
        "Горный воздух",
        "Краснодар",
        "Казань",
        "Омск",
        "Москва",
        "Санкт Петербург",
        "Сочи",
        "Горный воздух",
        "Краснодар",
        "Казань",
        "Омск"
    ]
    
    private var filteredCities: [String] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return cities
        }
        return cities.filter { city in
            city.localizedCaseInsensitiveContains(trimmedQuery)
        }
    }
    
    init(onSelect: @escaping (String) -> Void = { _ in }) {
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: Layout.backButtonSize, weight: .semibold))
                        .foregroundStyle(Color.customBlack)
                        .frame(width: Layout.backButtonSize, height: Layout.backButtonSize)
                }
                
                Spacer()
                
                Text("Выбор города")
                    .font(.system(size: Layout.titleFontSize, weight: .semibold))
                    .foregroundStyle(Color.customBlack)
                
                Spacer()
                
                Color.clear
                    .frame(width: Layout.backButtonSize, height: Layout.backButtonSize)
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.top, Layout.topPadding)
            
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
            
            if filteredCities.isEmpty {
                Spacer()
                
                Text("Город не найден")
                    .font(.system(size: Layout.emptyTitleSize, weight: .semibold))
                    .foregroundStyle(Color.customBlack)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            } else {
                List {
                    ForEach(filteredCities, id: \.self) { city in
                        Button {
                            onSelect(city)
                            dismiss()
                        } label: {
                            HStack {
                                Text(city)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.customBlack)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: Layout.rowChevronSize, weight: .semibold))
                                    .foregroundStyle(Color.customBlack)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
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
    }
}

#Preview {
    CitiesListView()
}
