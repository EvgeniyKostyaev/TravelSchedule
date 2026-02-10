//
//  ScheduleView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 10.02.2026.
//

import SwiftUI

enum ActiveField {
    case from
    case to
}

struct ScheduleView: View {
    private enum Layout {
        static let headerSpacing: CGFloat = 16
        static let carouselSpacing: CGFloat = 16
        static let carouselHeight: CGFloat = 144
        static let carouselContainerHeight: CGFloat = 188
        static let cardSpacing: CGFloat = 16
        static let textFieldFontSize: CGFloat = 17
        static let textFieldHorizontalPadding: CGFloat = 16
        static let textFieldCornerRadius: CGFloat = 20
        static let swapIconSize: CGFloat = 16
        static let swapButtonSize: CGFloat = 36
        static let cardPadding: CGFloat = 16
        static let cardCornerRadius: CGFloat = 20
        static let screenPadding: CGFloat = 16
    }
    
    @State private var fromText: String = String()
    @State private var toText: String = String()
    @State private var activeField: ActiveField?
    @State private var isCitiesPresenting: Bool = false
    @State private var isCarriersPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.headerSpacing) {
            ZStack() {
                LazyHStack(spacing: Layout.carouselSpacing) {
                    
                }
                .frame(height: Layout.carouselHeight)
            }
            .frame(height: Layout.carouselContainerHeight)
            
            HStack(spacing: Layout.cardSpacing) {
                VStack(alignment: .leading, spacing: 0) {
                    Button {
                        activeField = .from
                        isCitiesPresenting = true
                    } label: {
                        Text(fromText.isEmpty ? "Откуда" : fromText)
                            .foregroundStyle(fromText.isEmpty ? Color.customGray : .black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 48)
                    
                    Button {
                        activeField = .to
                        isCitiesPresenting = true
                    } label: {
                        Text(toText.isEmpty ? "Куда" : toText)
                            .foregroundStyle(toText.isEmpty ? Color.customGray : .black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 48)
                }
                .font(.system(size: Layout.textFieldFontSize, weight: .regular))
                .padding(.horizontal, Layout.textFieldHorizontalPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: Layout.textFieldCornerRadius, style: .continuous)
                )
                
                Button {
                    let temp = fromText
                    fromText = toText
                    toText = temp
                } label: {
                    Image(.swapButton)
                        .font(.system(size: Layout.swapIconSize, weight: .semibold))
                        .foregroundStyle(Color.customBlue)
                        .frame(width: Layout.swapButtonSize, height: Layout.swapButtonSize)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            .padding(Layout.cardPadding)
            .background(Color.customBlue)
            .clipShape(
                RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
            )
            
            if (!fromText.isEmpty && !toText.isEmpty) {
                HStack {
                    Spacer()
                    
                    Button {
                        isCarriersPresented = true
                    } label: {
                        Text("Найти")
                            .foregroundStyle(.customWhite)
                            .font(.system(size: Layout.textFieldFontSize, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(width: 150, height: 60, alignment: .center)
                    .background(Color.customBlue)
                    .clipShape(
                        RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                    )
                    
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding(Layout.screenPadding)
        .fullScreenCover(isPresented: $isCitiesPresenting) {
            CityStationSelectionFlowView { city, station in
                let value = "\(city) (\(station))"
                switch activeField {
                case .from:
                    fromText = value
                case .to:
                    toText = value
                case .none:
                    break
                }
                activeField = nil
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCitiesPresenting = false
                }
            }
        }
        .fullScreenCover(isPresented: $isCarriersPresented) {
            CarriersListView()
        }
    }
}

#Preview {
    ScheduleView()
}
