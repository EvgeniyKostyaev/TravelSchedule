//
//  CarrierCardView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 10.02.2026.
//

import SwiftUI

private enum Layout {
    static let titleSpacing: CGFloat = 8
    static let iconSize: CGFloat = 38
    static let titleFontSize: CGFloat = 17
    static let subtitleFontSize: CGFloat = 12
    static let timeFontSize: CGFloat = 17
    static let timeRowHeight: CGFloat = 48
    static let cardPadding: CGFloat = 12
    static let cardCornerRadius: CGFloat = 16
    static let iconCornerRadius: CGFloat = 12
    static let titleStackSpacing: CGFloat = 2
    static let timeStackSpacing: CGFloat = 8
    static let dividerHeight: CGFloat = 1
    static let fallbackIconFontSize: CGFloat = 18
}

struct CarrierCellView: View {
    var option: CarrierOption
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.titleSpacing) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: Layout.iconCornerRadius, style: .continuous)
                        .fill(Color.customWhite)
                    if let logoURL = option.logoURL {
                        AsyncImage(url: logoURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: Layout.iconCornerRadius, style: .continuous))
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "train.side.front.car")
                            .font(.system(size: Layout.fallbackIconFontSize, weight: .bold))
                            .foregroundStyle(Color.customRed)
                            .clipShape(RoundedRectangle(cornerRadius: Layout.iconCornerRadius, style: .continuous))
                    }
                }
                .frame(width: Layout.iconSize, height: Layout.iconSize)
                
                VStack(alignment: .leading, spacing: Layout.titleStackSpacing) {
                    Text(option.carrierName)
                        .font(.system(size: Layout.titleFontSize, weight: .regular))
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
                    .foregroundStyle(Color.customBlack)
            }
            .frame(maxWidth: .infinity)
            
            HStack(spacing: Layout.timeStackSpacing) {
                Text(option.departureTime)
                    .font(.system(size: Layout.timeFontSize, weight: .regular))
                    .foregroundStyle(Color.customBlack)
                
                Rectangle()
                    .fill(Color.customGray)
                    .frame(height: Layout.dividerHeight)
                
                Text(option.durationLabel)
                    .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                    .foregroundStyle(Color.customBlack)
                
                Rectangle()
                    .fill(Color.customGray)
                    .frame(height: Layout.dividerHeight)
                
                Text(option.arrivalTime)
                    .font(.system(size: Layout.timeFontSize, weight: .regular))
                    .foregroundStyle(Color.customBlack)
            }
            .frame(height: Layout.timeRowHeight)
        }
        .padding(Layout.cardPadding)
        .background(Color.customLightGray)
        .colorScheme(.light)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous))
        
    }
}

#Preview {
    CarrierCellView(option: CarrierOption(
        carrierName: "РЖД",
        routeTitle: "Москва (Ярославский вокзал) → Санкт Петербург (Балтийский вокзал)",
        routeNote: "С пересадкой в Костроме",
        dateLabel: "14 января",
        departureTime: "22:30",
        arrivalTime: "08:15",
        durationLabel: "20 часов",
        hasTransfers: true,
        timeSlot: .night,
        logoURL: URL(string: "https://picsum.photos/seed/rzd-preview/100/100"),
        email: "info@rzd.ru",
        phone: "+7 (904) 329-27-71"
    ))
}
