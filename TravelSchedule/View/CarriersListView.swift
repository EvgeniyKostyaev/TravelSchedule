//
//  CarriersListView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 10.02.2026.
//

import SwiftUI

struct CarriersListView: View {
    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 16
        static let cardCornerRadius: CGFloat = 16
        static let cardPadding: CGFloat = 12
        static let cardSpacing: CGFloat = 12
        static let titleSpacing: CGFloat = 8
        static let titleFontSize: CGFloat = 17
        static let headerFontSize: CGFloat = 24
        static let subtitleFontSize: CGFloat = 13
        static let timeFontSize: CGFloat = 17
        static let buttonHeight: CGFloat = 60
        static let buttonCornerRadius: CGFloat = 12
        static let buttonDotSize: CGFloat = 6
        static let iconSize: CGFloat = 38
        static let timeRowHeight: CGFloat = 48
        static let timeDividerWidth: CGFloat = 56
    }
    
    private enum Route: Hashable {
        case filters
    }
    
    private struct CarrierOption: Identifiable {
        let id = UUID()
        let carrierName: String
        let routeTitle: String
        let routeNote: String
        let dateLabel: String
        let departureTime: String
        let arrivalTime: String
        let durationLabel: String
        let hasTransfers: Bool
        let timeSlot: TimeSlot
    }
    
    enum TimeSlot: String, CaseIterable, Identifiable {
        case morning = "Утро 06:00 - 12:00"
        case day = "День 12:00 - 18:00"
        case evening = "Вечер 18:00 - 00:00"
        case night = "Ночь 00:00 - 06:00"
        
        var id: String { rawValue }
    }
    
    enum TransfersFilter: String {
        case yes
        case no
    }
    
    struct FiltersState {
        var selectedSlots: Set<TimeSlot> = []
        var transfers: TransfersFilter? = nil
        
        var isActive: Bool {
            !selectedSlots.isEmpty || transfers != nil
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var path = NavigationPath()
    @State private var filters = FiltersState()
    
    private let fromText: String
    private let toText: String
    private let options: [CarrierOption] = [
        CarrierOption(
            carrierName: "РЖД",
            routeTitle: "Москва (Ярославский вокзал) → Санкт Петербург (Балтийский вокзал)",
            routeNote: "С пересадкой в Костроме",
            dateLabel: "14 января",
            departureTime: "22:30",
            arrivalTime: "08:15",
            durationLabel: "20 часов",
            hasTransfers: true,
            timeSlot: .night
        ),
        CarrierOption(
            carrierName: "ФК",
            routeTitle: "Москва (Ярославский вокзал) → Санкт Петербург (Балтийский вокзал)",
            routeNote: "",
            dateLabel: "15 января",
            departureTime: "01:15",
            arrivalTime: "09:00",
            durationLabel: "9 часов",
            hasTransfers: false,
            timeSlot: .night
        ),
        CarrierOption(
            carrierName: "Урал логистика",
            routeTitle: "Москва (Ярославский вокзал) → Санкт Петербург (Балтийский вокзал)",
            routeNote: "",
            dateLabel: "16 января",
            departureTime: "12:30",
            arrivalTime: "21:00",
            durationLabel: "9 часов",
            hasTransfers: false,
            timeSlot: .day
        )
    ]
    
    private var filteredOptions: [CarrierOption] {
        options.filter { option in
            let slotMatches = filters.selectedSlots.isEmpty || filters.selectedSlots.contains(option.timeSlot)
            let transferMatches: Bool
            switch filters.transfers {
            case .none:
                transferMatches = true
            case .some(.yes):
                transferMatches = option.hasTransfers
            case .some(.no):
                transferMatches = !option.hasTransfers
            }
            return slotMatches && transferMatches
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: Layout.sectionSpacing) {
                Text("\(fromText) → \(toText)")
                    .font(.system(size: Layout.headerFontSize, weight: .bold))
                    .foregroundStyle(Color.customBlack)
                    .padding(.horizontal, Layout.horizontalPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if filteredOptions.isEmpty {
                    Spacer()
                    
                    Text("Вариантов нет")
                        .font(.system(size: Layout.titleFontSize, weight: .semibold))
                        .foregroundStyle(Color.customBlack)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                } else {
                    List {
                        ForEach(filteredOptions) { option in
                            carrierCard(option)
                                .listRowInsets(
                                    EdgeInsets(
                                        top: 0,
                                        leading: Layout.horizontalPadding,
                                        bottom: Layout.cardSpacing,
                                        trailing: Layout.horizontalPadding
                                    )
                                )
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.customWhite)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                
                Button {
                    path.append(Route.filters)
                } label: {
                    HStack(spacing: 6) {
                        Text("Уточнить время")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.customWhite)
                        if filters.isActive {
                            Circle()
                                .fill(Color.customRed)
                                .frame(width: Layout.buttonDotSize, height: Layout.buttonDotSize)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: Layout.buttonHeight)
                }
                .background(Color.customBlue)
                .clipShape(RoundedRectangle(cornerRadius: Layout.buttonCornerRadius, style: .continuous))
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, Layout.horizontalPadding)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.customBlack)
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .filters:
                    FiltersView(filters: $filters) {
                        path.removeLast()
                    }
                }
            }
        }
    }
    
    init(fromText: String, toText: String) {
        self.fromText = fromText
        self.toText = toText
    }
    
    private func carrierCard(_ option: CarrierOption) -> some View {
        VStack(alignment: .leading, spacing: Layout.titleSpacing) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.customWhite)
                    Image(systemName: "train.side.front.car")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.customRed)
                }
                .frame(width: Layout.iconSize, height: Layout.iconSize)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(option.carrierName)
                        .font(.system(size: Layout.titleFontSize, weight: .semibold))
                        .foregroundStyle(Color.customBlack)
                    if !option.routeNote.isEmpty {
                        Text(option.routeNote)
                            .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                            .foregroundStyle(Color.customRed)
                    }
                }
                
                Spacer()
                Text(option.dateLabel)
                    .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                    .foregroundStyle(Color.customGray)
            }
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 8) {
                Text(option.departureTime)
                    .font(.system(size: Layout.timeFontSize, weight: .semibold))
                    .foregroundStyle(Color.customBlack)
                
                Rectangle()
                    .fill(Color.customLightGray)
                    .frame(height: 1)
                
                Text(option.durationLabel)
                    .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                    .foregroundStyle(Color.customGray)
                
                Rectangle()
                    .fill(Color.customLightGray)
                    .frame(height: 1)
                
                Text(option.arrivalTime)
                    .font(.system(size: Layout.timeFontSize, weight: .semibold))
                    .foregroundStyle(Color.customBlack)
            }
            .frame(height: Layout.timeRowHeight)
        }
        .padding(Layout.cardPadding)
        .background(Color.customLightGray)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous))
    }
}

#Preview {
    CarriersListView(fromText: "Москва (Ярославский вокзал)", toText: "Санкт Петербург (Балтийский вокзал)")
}
