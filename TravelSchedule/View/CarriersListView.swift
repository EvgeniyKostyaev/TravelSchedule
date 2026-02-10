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
        static let cardCornerRadius: CGFloat = 12
        static let cardPadding: CGFloat = 12
        static let cardSpacing: CGFloat = 12
        static let titleSpacing: CGFloat = 8
        static let titleFontSize: CGFloat = 17
        static let headerFontSize: CGFloat = 15
        static let subtitleFontSize: CGFloat = 13
        static let timeFontSize: CGFloat = 15
        static let buttonHeight: CGFloat = 44
        static let buttonCornerRadius: CGFloat = 12
        static let buttonDotSize: CGFloat = 6
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
                Text("Москва (Ярославский вокзал) → Санкт Петербург (Балтийский вокзал)")
                    .font(.system(size: Layout.headerFontSize, weight: .semibold))
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
                    ScrollView {
                        VStack(spacing: Layout.cardSpacing) {
                            ForEach(filteredOptions) { option in
                                carrierCard(option)
                            }
                        }
                        .padding(.horizontal, Layout.horizontalPadding)
                    }
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
                .padding(.bottom, 12)
            }
            .navigationTitle("Список перевозчиков")
            .navigationBarTitleDisplayMode(.inline)
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
    
    private func carrierCard(_ option: CarrierOption) -> some View {
        VStack(alignment: .leading, spacing: Layout.titleSpacing) {
            HStack {
                Text(option.carrierName)
                    .font(.system(size: Layout.titleFontSize, weight: .semibold))
                    .foregroundStyle(Color.customBlack)
                Spacer()
                Text(option.dateLabel)
                    .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                    .foregroundStyle(Color.customGray)
            }
            
            if !option.routeNote.isEmpty {
                Text(option.routeNote)
                    .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                    .foregroundStyle(Color.customRed)
            }
            
            HStack {
                Text(option.departureTime)
                    .font(.system(size: Layout.timeFontSize, weight: .semibold))
                Spacer()
                Text(option.durationLabel)
                    .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                    .foregroundStyle(Color.customGray)
                Spacer()
                Text(option.arrivalTime)
                    .font(.system(size: Layout.timeFontSize, weight: .semibold))
            }
            .foregroundStyle(Color.customBlack)
        }
        .padding(Layout.cardPadding)
        .background(Color.customWhite)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}

#Preview {
    CarriersListView()
}
