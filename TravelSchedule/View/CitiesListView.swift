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
        static let searchHorizontalPadding: CGFloat = 12
        static let sectionSpacing: CGFloat = 16
        static let rowSpacing: CGFloat = 24
        static let rowChevronSize: CGFloat = 20
    }
    
    @State private var query: String = ""
    
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            HStack {
                Button {
                    // TODO: Back action
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
            }
            .padding(.horizontal, Layout.searchHorizontalPadding)
            .frame(height: Layout.searchHeight)
            .background(Color.customLightGray)
            .clipShape(
                RoundedRectangle(cornerRadius: Layout.searchCornerRadius, style: .continuous)
            )
            .padding(.horizontal, Layout.horizontalPadding)
            
            List {
                ForEach(cities, id: \.self) { city in
                    HStack {
                        Text(city)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color.customBlack)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: Layout.rowChevronSize, weight: .semibold))
                            .foregroundStyle(Color.customBlack)
                    }
                    .listRowInsets(
                        EdgeInsets(
                            top: Layout.rowSpacing / 2,
                            leading: Layout.horizontalPadding,
                            bottom: Layout.rowSpacing / 2,
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
        .background(Color.customWhite)
    }
}

#Preview {
    CitiesListView()
}
