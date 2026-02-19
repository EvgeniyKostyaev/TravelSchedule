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

private enum Layout {
    static let headerSpacing: CGFloat = 16
    static let storiesHeight: CGFloat = 140
    static let cardSpacing: CGFloat = 16
    static let textFieldFontSize: CGFloat = 17
    static let textFieldHorizontalPadding: CGFloat = 16
    static let textFieldCornerRadius: CGFloat = 20
    static let swapIconSize: CGFloat = 16
    static let swapButtonSize: CGFloat = 36
    static let cardPadding: CGFloat = 16
    static let cardCornerRadius: CGFloat = 20
    static let screenPadding: CGFloat = 16
    static let textFieldStackSpacing: CGFloat = 0
    static let textFieldRowHeight: CGFloat = 48
    static let textLineLimit: Int = 1
    static let searchButtonWidth: CGFloat = 150
    static let searchButtonHeight: CGFloat = 60
    static let dismissAnimationDuration: CGFloat = 0.2
    static let storiesBottomPadding: CGFloat = 24
}

struct ScheduleView: View {
    @StateObject private var viewModel: ScheduleViewModel = ScheduleViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.headerSpacing) {
            StoriesStripView(
                stories: viewModel.stories,
                viewedStoryIDs: viewModel.viewedStoryIDs
            ) { index in
                viewModel.onShowStoriesView(selectedStoryIndex: index)
            }
            .frame(height: Layout.storiesHeight)
            .padding(.trailing, -Layout.screenPadding)
            .padding(.bottom, Layout.storiesBottomPadding)
            
            HStack(spacing: Layout.cardSpacing) {
                VStack(alignment: .leading, spacing: Layout.textFieldStackSpacing) {
                    Button {
                        viewModel.onShowCities(activeField: .from)
                    } label: {
                        Text(viewModel.fromText.isEmpty ? "Откуда" : viewModel.fromText)
                            .foregroundStyle(viewModel.fromText.isEmpty ? Color.customGray : .customBlack)
                            .colorScheme(.light)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(Layout.textLineLimit)
                    }
                    .frame(height: Layout.textFieldRowHeight)
                    
                    Button {
                        viewModel.onShowCities(activeField: .to)
                    } label: {
                        Text(viewModel.toText.isEmpty ? "Куда" : viewModel.toText)
                            .foregroundStyle(viewModel.toText.isEmpty ? Color.customGray : .customBlack)
                            .colorScheme(.light)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(Layout.textLineLimit)
                    }
                    .frame(height: Layout.textFieldRowHeight)
                }
                .font(.system(size: Layout.textFieldFontSize, weight: .regular))
                .padding(.horizontal, Layout.textFieldHorizontalPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.customWhite)
                .colorScheme(.light)
                .clipShape(
                    RoundedRectangle(cornerRadius: Layout.textFieldCornerRadius, style: .continuous)
                )
                
                Button {
                    viewModel.onSwapFromToData()
                } label: {
                    Image(.swapButton)
                        .font(.system(size: Layout.swapIconSize, weight: .semibold))
                        .foregroundStyle(Color.customBlue)
                        .frame(width: Layout.swapButtonSize, height: Layout.swapButtonSize)
                        .background(Color.customWhite)
                        .colorScheme(.light)
                        .clipShape(Circle())
                }
            }
            .padding(Layout.cardPadding)
            .background(Color.customBlue)
            .clipShape(
                RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
            )
            
            if !viewModel.fromCode.isEmpty && !viewModel.toCode.isEmpty {
                HStack {
                    Spacer()
                    Button {
                        viewModel.onShowCarriersView()
                    } label: {
                        Text("Найти")
                            .foregroundStyle(.customWhite)
                            .colorScheme(.light)
                            .font(.system(size: Layout.textFieldFontSize, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(width: Layout.searchButtonWidth, height: Layout.searchButtonHeight, alignment: .center)
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
        .fullScreenCover(isPresented: $viewModel.isCitiesPresenting) {
            CityStationSelectionFlowView { city, station in
                let stationTitle = station.title.trimmingCharacters(in: .whitespacesAndNewlines)
                let value: String
                if stationTitle.localizedCaseInsensitiveContains(city) {
                    value = stationTitle
                } else {
                    value = "\(city) (\(stationTitle))"
                }
                switch viewModel.activeField {
                case .from:
                    viewModel.onUpdateFromData(fromText: value, fromCode: station.code)
                case .to:
                    viewModel.onUpdateToData(toText: value, toCode: station.code)
                case .none:
                    break
                }
                withAnimation(.easeInOut(duration: Layout.dismissAnimationDuration)) {
                    viewModel.onHideCitiesView()
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isCarriersPresented) {
            CarriersListView(
                fromText: viewModel.fromText,
                toText: viewModel.toText,
                fromCode: viewModel.fromCode,
                toCode: viewModel.toCode
            )
        }
        .fullScreenCover(isPresented: $viewModel.isStoriesPresented) {
            StoriesScreenView(
                stories: viewModel.stories,
                viewedStoryIDs: $viewModel.viewedStoryIDs,
                initialStoryIndex: viewModel.selectedStoryIndex
            ) {
                viewModel.onHideStoriesView()
            }
        }
    }
}

#Preview {
    ScheduleView()
}
