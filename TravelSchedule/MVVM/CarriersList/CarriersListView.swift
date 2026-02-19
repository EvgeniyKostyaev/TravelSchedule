//
//  CarriersListView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 10.02.2026.
//

import SwiftUI

private enum Layout {
    static let horizontalPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 16
    static let cardSpacing: CGFloat = 12
    static let titleFontSize: CGFloat = 24
    static let headerFontSize: CGFloat = 24
    static let buttonHeight: CGFloat = 60
    static let buttonCornerRadius: CGFloat = 12
    static let buttonDotSize: CGFloat = 6
    static let listRowInsetTop: CGFloat = 0
    static let buttonLabelSpacing: CGFloat = 6
    static let buttonFontSize: CGFloat = 17
}

@MainActor
struct CarriersListView: View {
    private enum Route: Hashable {
        case filters
        case carrierDetails(CarrierOption)
    }

    @StateObject private var viewModel: CarriersListViewModel
    @State private var path = NavigationPath()

    init(fromText: String, toText: String, fromCode: String, toCode: String) {
        _viewModel = StateObject(
            wrappedValue: CarriersListViewModel(
                fromText: fromText,
                toText: toText,
                fromCode: fromCode,
                toCode: toCode
            )
        )
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: Layout.sectionSpacing) {
                Text(viewModel.headerTitle)
                    .font(.system(size: Layout.headerFontSize, weight: .bold))
                    .foregroundStyle(Color.customBlack)
                    .padding(.horizontal, Layout.horizontalPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)

                contentView

                if shouldShowFiltersButton {
                    Button {
                        path.append(Route.filters)
                    } label: {
                        HStack(spacing: Layout.buttonLabelSpacing) {
                            Text("Уточнить время")
                                .font(.system(size: Layout.buttonFontSize, weight: .bold))
                                .foregroundStyle(Color.customWhite)
                                .colorScheme(.light)

                            if viewModel.filters.isActive {
                                Circle()
                                    .fill(Color.customRed)
                                    .frame(width: Layout.buttonDotSize, height: Layout.buttonDotSize)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: Layout.buttonHeight)
                    }
                    .background(Color.customBlue)
                    .clipShape(
                        RoundedRectangle(cornerRadius: Layout.buttonCornerRadius, style: .continuous)
                    )
                    .padding(.horizontal, Layout.horizontalPadding)
                    .padding(.bottom, Layout.horizontalPadding)
                }
            }
            .customNavigationBackButton()
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .filters:
                    FiltersView(filters: viewModel.filters) { filters in
                        viewModel.onUpdateFilters(filters)
                        path.removeLast()
                    }
                case .carrierDetails(let option):
                    CarrierDetailsView(option: option)
                }
            }
            .task {
                await viewModel.load()
            }
        }
    }

    private var shouldShowFiltersButton: Bool {
        viewModel.errorKind == nil && !viewModel.options.isEmpty
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading && viewModel.options.isEmpty {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorKind = viewModel.errorKind, viewModel.options.isEmpty {
            ErrorStateView(errorState: errorKind == .noInternet ? .noInternet : .serverError)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.filteredOptions.isEmpty {
            Spacer()

            Text("Вариантов нет")
                .font(.system(size: Layout.titleFontSize, weight: .bold))
                .foregroundStyle(Color.customBlack)
                .frame(maxWidth: .infinity, alignment: .center)

            Spacer()
        } else {
            List {
                ForEach(viewModel.filteredOptions) { option in
                    Button {
                        path.append(Route.carrierDetails(option))
                    } label: {
                        CarrierCellView(option: option)
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(
                        EdgeInsets(
                            top: Layout.listRowInsetTop,
                            leading: Layout.horizontalPadding,
                            bottom: Layout.cardSpacing,
                            trailing: Layout.horizontalPadding
                        )
                    )
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    CarriersListView(
        fromText: "Москва (Ярославский вокзал)",
        toText: "Санкт Петербург (Балтийский вокзал)",
        fromCode: "s9602492",
        toCode: "s9600213"
    )
}
