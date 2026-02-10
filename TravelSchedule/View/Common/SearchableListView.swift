//
//  SearchableListView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 10.02.2026.
//

import SwiftUI

struct SearchableListView: View {
    private struct RowHighlightButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(
                    RoundedRectangle(cornerRadius: Layout.rowHighlightCornerRadius, style: .continuous)
                        .fill(Color.customLightGray.opacity(configuration.isPressed ? Layout.highlightPressedOpacity : Layout.highlightRestOpacity))
                )
                .animation(.easeInOut(duration: Layout.highlightAnimationDuration), value: configuration.isPressed)
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
        static let searchStackSpacing: CGFloat = 8
        static let textFontSize: CGFloat = 17
        static let rowHighlightCornerRadius: CGFloat = 12
        static let highlightPressedOpacity: CGFloat = 0.6
        static let highlightRestOpacity: CGFloat = 0.0
        static let highlightAnimationDuration: CGFloat = 0.15
        static let listRowInsetTop: CGFloat = 0
        static let listRowInsetBottom: CGFloat = 0
    }
    
    @State private var query: String = ""
    
    private let title: String
    private let placeholder: String
    private let emptyTitle: String
    private let items: [String]
    private let onSelect: (String) -> Void
    
    private var filteredItems: [String] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return items
        }
        return items.filter { item in
            item.localizedCaseInsensitiveContains(trimmedQuery)
        }
    }
    
    init(
        title: String,
        placeholder: String,
        emptyTitle: String,
        items: [String],
        onSelect: @escaping (String) -> Void = { _ in }
    ) {
        self.title = title
        self.placeholder = placeholder
        self.emptyTitle = emptyTitle
        self.items = items
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            HStack(spacing: Layout.searchStackSpacing) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: Layout.searchIconSize, weight: .regular))
                    .foregroundStyle(Color.customGray)
                
                TextField(
                    "",
                    text: $query,
                    prompt: Text(placeholder).foregroundStyle(Color.customGray)
                )
                .foregroundStyle(Color.customBlack)
                .font(.system(size: Layout.textFontSize, weight: .regular))
                
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
            
            if filteredItems.isEmpty {
                Spacer()
                
                Text(emptyTitle)
                    .font(.system(size: Layout.emptyTitleSize, weight: .semibold))
                    .foregroundStyle(Color.customBlack)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            } else {
                List {
                    ForEach(filteredItems, id: \.self) { item in
                        Button {
                            onSelect(item)
                        } label: {
                            HStack {
                                Text(item)
                                    .font(.system(size: Layout.textFontSize, weight: .regular))
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
                                top: Layout.listRowInsetTop,
                                leading: Layout.horizontalPadding,
                                bottom: Layout.listRowInsetBottom,
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
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SearchableListView(
            title: "Выбор города",
            placeholder: "Введите запрос",
            emptyTitle: "Город не найден",
            items: ["Москва", "Санкт Петербург", "Сочи"]
        )
    }
}
