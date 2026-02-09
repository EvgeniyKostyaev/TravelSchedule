//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 29.01.2026.
//

import SwiftUI

enum Tab: Int {
    case schedule
    case settings
}

struct ContentView: View {
    @State private var selectedTab: Tab = .schedule
    @State private var schedulePath = NavigationPath()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.customWhite
                .ignoresSafeArea(edges: .bottom)
            Group {
                switch selectedTab {
                case .schedule:
                    ScheduleView(path: $schedulePath)
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if schedulePath.isEmpty {
                BottomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    struct ScheduleView: View {
        enum Route: Hashable {
            case cities(ActiveField)
            case stations(ActiveField, String)
        }
        
        enum ActiveField: String, Identifiable {
            case from
            case to
            
            var id: String { rawValue }
        }
        
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
        
        @Binding var path: NavigationPath
        @State private var fromText: String = String()
        @State private var toText: String = String()
        
        var body: some View {
            NavigationStack(path: $path) {
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
                                path.append(Route.cities(.from))
                            } label: {
                                Text(fromText.isEmpty ? "Откуда" : fromText)
                                    .foregroundStyle(fromText.isEmpty ? Color.customGray : .black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(height: 48)
                            
                            Button {
                                path.append(Route.cities(.to))
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
                    
                    Spacer()
                }
                .padding(Layout.screenPadding)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .cities(let field):
                        CitiesListView { city in
                            path.append(Route.stations(field, city))
                        }
                    case .stations(let field, let city):
                        StationsListView(city: city) { station in
                            let value = "\(city) (\(station))"
                            switch field {
                            case .from:
                                fromText = value
                            case .to:
                                toText = value
                            }
                            path = NavigationPath()
                        }
                    }
                }
            }
        }
    }
    
    struct SettingsView: View {
        var body: some View {
            Color.customWhite.opacity(0.1)
                .overlay(Text("Settings"))
        }
    }
    
    struct BottomTabBar: View {
        private enum Layout {
            static let containerSpacing: CGFloat = 0
            static let horizontalPadding: CGFloat = 56
            static let iconSize: CGFloat = 30
            static let buttonWidth: CGFloat = 75
            static let buttonHeight: CGFloat = 49
        }
        
        @Binding var selectedTab: Tab
        
        var body: some View {
            VStack(spacing: Layout.containerSpacing) {
                Divider()
                HStack {
                    tabButton(
                        image: Image(.scheduleTab),
                        tab: .schedule
                    )
                    
                    Spacer()
                    
                    tabButton(
                        image: Image(.settingsTab),
                        tab: .settings
                    )
                }
                .padding(.horizontal, Layout.horizontalPadding)
            }
        }
        
        private func tabButton(image: Image, tab: Tab) -> some View {
            Button {
                withAnimation(.easeInOut) {
                    selectedTab = tab
                }
            } label: {
                image
                    .renderingMode(.template)
                    .foregroundStyle(
                        selectedTab == tab ? .customBlack : .customGray
                    )
                    .frame(width: Layout.iconSize, height: Layout.iconSize)
            }
            .frame(width: Layout.buttonWidth, height: Layout.buttonHeight)
        }
    }
    
    
    // MARK: - Helper methods
    private func testFetchStations() {
        Task {
            do {
                let service = NetworkClientFactory.shared.makeNearestStationsService()
                
                print("Fetching ...")
                let stations = try await service.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                
                print("Successfully fetched: \(stations)")
            } catch {
                
                print("Error fetching: \(error)")
            }
        }
    }
    
    private func testFetchRouteSegmentSchedules() {
        Task {
            do {
                let service = NetworkClientFactory.shared.makeSearchService()
                
                print("Fetching...")
                let schedules = try await service.getScheduleBetweenStations(from: "s9600213", to: "c146")
                
                print("Successfully fetched: \(schedules)")
            } catch {
                
                print("Error fetching: \(error)")
            }
        }
    }
    
    private func testFetchSchedule() {
        Task {
            do {
                let service = NetworkClientFactory.shared.makeScheduleService()
                
                print("Fetching...")
                let schedule = try await service.getStationSchedule(station: "s9600213")
                
                print("Successfully fetched: \(schedule)")
            } catch {
                
                print("Error fetching: \(error)")
            }
        }
    }
    
    private func testFetchThreadStations() {
        Task {
            do {
                let service = NetworkClientFactory.shared.makeThreadService()
                
                print("Fetching...")
                let threadStations = try await service.getRouteStations(uid: "038AA_tis")
                
                print("Successfully fetched: \(threadStations)")
            } catch {
                
                print("Error fetching: \(error)")
            }
        }
    }
    
    private func testFetchNearestCity() {
        Task {
            do {
                let service = NetworkClientFactory.shared.makeNearestSettlementService()
                
                print("Fetching...")
                let nearestCity = try await service.getNearestCity(lat: 59.864177, lng: 30.319163)
                
                print("Successfully fetched: \(nearestCity)")
            } catch {
                
                print("Error fetching: \(error)")
            }
        }
    }
    
    private func testFetchCarrier() {
        Task {
            do {
                let service = NetworkClientFactory.shared.makeCarrierService()
                
                print("Fetching...")
                let carrier = try await service.getCarrierInfo(code: "TK", system: "iata", lang: "ru_RU", format: "json")
                
                print("Successfully fetched: \(carrier)")
            } catch {
                
                print("Error fetching: \(error)")
            }
        }
    }
    
    private func testFetchAllStations() {
        Task {
            do {
                let service = NetworkClientFactory.shared.makeStationsListService()
                
                print("Fetching...")
                let carrier = try await service.getAllStations()
                
                print("Successfully fetched: \(carrier)")
            } catch {
                
                print("Error fetching: \(error)")
            }
        }
    }
    
    private func testFetchScheduleBannersData() {
        Task {
            do {
                let service = NetworkClientFactory.shared.makeCopyrightService()
                
                print("Fetching...")
                let scheduleBannersData = try await service.getScheduleBannersData()
                
                print("Successfully fetched: \(scheduleBannersData)")
            } catch {
                
                print("Error fetching: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
