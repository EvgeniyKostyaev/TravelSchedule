//
//  CarrierDetailsView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import SwiftUI

private enum Layout {
    static let logoHeight: CGFloat = 104
    static let titleFontSize: CGFloat = 24
    static let labelFontSize: CGFloat = 17
    static let valueFontSize: CGFloat = 12
    static let rowSpacing: CGFloat = 28
    static let fallbackLogoFontSize: CGFloat = 56
    static let logoCornerRadius: CGFloat = 12
}

struct CarrierDetailsView: View {
    let option: CarrierOption
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: Layout.logoCornerRadius, style: .continuous)
                    .fill(Color.customWhite)
                if let logoURL = option.logoURL {
                    AsyncImage(url: logoURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "tram.fill")
                        .font(.system(size: Layout.fallbackLogoFontSize, weight: .bold))
                        .foregroundStyle(Color.customRed)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: Layout.logoHeight)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: Layout.logoCornerRadius, style: .continuous))
            .padding(.top)
            
            VStack(alignment: .leading, spacing: Layout.rowSpacing) {
                Text(option.carrierName)
                    .font(.system(size: Layout.titleFontSize, weight: .bold))
                    .foregroundStyle(Color.customBlack)
                
                VStack(alignment: .leading, spacing: .zero) {
                    Text("E-mail")
                        .font(.system(size: Layout.labelFontSize, weight: .regular))
                        .foregroundStyle(Color.customBlack)
                    
                    Text(option.email)
                        .font(.system(size: Layout.valueFontSize, weight: .regular))
                        .foregroundStyle(Color.customBlue)
                }
                
                VStack(alignment: .leading, spacing: .zero) {
                    Text("Телефон")
                        .font(.system(size: Layout.labelFontSize, weight: .regular))
                        .foregroundStyle(Color.customBlack)
                    
                    Text(option.phone)
                        .font(.system(size: Layout.valueFontSize, weight: .regular))
                        .foregroundStyle(Color.customBlue)
                }
            }
            .padding(.top)
            
            Spacer()
        }
        .customNavigationBackButton()
        .padding(.horizontal)
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CarrierDetailsView(
            option: CarrierOption(
                carrierName: "ОАО «РЖД»",
                routeTitle: "",
                routeNote: "",
                dateLabel: "14 января",
                departureTime: "22:30",
                arrivalTime: "08:15",
                durationLabel: "20 часов",
                hasTransfers: true,
                timeSlot: .night,
                logoURL: URL(string: "https://picsum.photos/seed/rzd-details/220/120"),
                email: "i.lozgkina@yandex.ru",
                phone: "+7 (904) 329-27-71"
            )
        )
    }
}
