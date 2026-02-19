//
//  FiltersView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 10.02.2026.
//

import SwiftUI

private enum Layout {
    static let horizontalPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 35
    static let rowSpacing: CGFloat = 30
    static let titleFontSize: CGFloat = 24
    static let subtitleFontSize: CGFloat = 17
    static let applyFontSize: CGFloat = 17
    static let buttonHeight: CGFloat = 60
    static let buttonCornerRadius: CGFloat = 12
    static let checkboxSize: CGFloat = 18
    static let radioSize: CGFloat = 18
    static let transfersTopPadding: CGFloat = 4
    static let buttonLabelSpacing: CGFloat = 6
}

struct CarriersFiltersView: View {
    @StateObject private var viewModel: CarriersFiltersViewModel

    private let onApply: (CarrierFiltersState) -> Void
    
    init(filters: CarrierFiltersState, onApply: @escaping (CarrierFiltersState) -> Void) {
        _viewModel = StateObject(wrappedValue: CarriersFiltersViewModel(filters: filters))
        self.onApply = onApply
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            Text("Время отправления")
                .font(.system(size: Layout.titleFontSize, weight: .bold))
                .foregroundStyle(Color.customBlack)
                .padding(.horizontal, Layout.horizontalPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: Layout.rowSpacing) {
                ForEach(TimeSlot.allCases) { slot in
                    Button {
                        viewModel.onToggleSlot(slot)
                    } label: {
                        HStack {
                            Text(slot.rawValue)
                                .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                                .foregroundStyle(Color.customBlack)
                            Spacer()
                            Image(systemName: viewModel.filters.selectedSlots.contains(slot) ? "checkmark.square.fill" : "square")
                                .font(.system(size: Layout.checkboxSize))
                                .foregroundStyle(Color.customBlack)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Layout.horizontalPadding)
            
            Text("Показывать варианты с пересадками")
                .font(.system(size: Layout.titleFontSize, weight: .semibold))
                .foregroundStyle(Color.customBlack)
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.top, Layout.transfersTopPadding)
            
            VStack(spacing: Layout.rowSpacing) {
                radioRow(title: "Да", value: .yes)
                radioRow(title: "Нет", value: .no)
            }
            .padding(.horizontal, Layout.horizontalPadding)
            
            Spacer()
            
            Button {
                onApply(viewModel.currentFilters())
            } label: {
                HStack(spacing: Layout.buttonLabelSpacing) {
                    Text("Применить")
                        .font(.system(size: Layout.applyFontSize, weight: .bold))
                        .foregroundStyle(Color.customWhite)
                        .colorScheme(.light)
                }
                .frame(maxWidth: .infinity, minHeight: Layout.buttonHeight)
            }
            .background(Color.customBlue)
            .clipShape(RoundedRectangle(cornerRadius: Layout.buttonCornerRadius, style: .continuous))
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.bottom, Layout.horizontalPadding)
        }
        .customNavigationBackButton()
    }
    
    private func radioRow(title: String, value: TransfersFilter) -> some View {
        Button {
            viewModel.onToggleTransfers(value)
        } label: {
            HStack {
                Text(title)
                    .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                    .foregroundStyle(Color.customBlack)
                Spacer()
                Image(systemName: viewModel.filters.transfers == value ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: Layout.radioSize))
                    .foregroundStyle(Color.customBlack)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CarriersFiltersView(filters: .init()) { _ in }
    }
}
