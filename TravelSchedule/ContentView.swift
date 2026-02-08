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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.customWhite
                .ignoresSafeArea(edges: .bottom)
            Group {
                switch selectedTab {
                case .schedule:
                    ScheduleView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            BottomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    struct ScheduleView: View {
        @State private var fromText: String = ""
        @State private var toText: String = ""
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("Откуда", text: $fromText)
                        TextField("Куда", text: $toText)
                    }
                    .font(.system(size: 16))
                    .foregroundStyle(Color.customWhite)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                    )
                    
                    Button {
                        let temp = fromText
                        fromText = toText
                        toText = temp
                    } label: {
                        Image(.swapButton)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.customBlue)
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                }
                .padding(16)
                .background(Color.customBlue)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                )
                
                Spacer()
            }
            .padding(16)
        }
    }
    
    struct SettingsView: View {
        var body: some View {
            Color.customWhite.opacity(0.1)
                .overlay(Text("Settings"))
        }
    }
    
    struct BottomTabBar: View {
        @Binding var selectedTab: Tab
        
        var body: some View {
            VStack(spacing: 0) {
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
                .padding(.horizontal, 56)
            }
            
            .background(
                Color.customWhite
                    .shadow(color: .black.opacity(0.05), radius: 8, y: -2)
            )
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
                    .frame(width: 30, height: 30)
            }
            .frame(width: 75, height: 49)
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
