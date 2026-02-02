//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 29.01.2026.
//

import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            testFetchStations()
            testFetchRouteSegmentSchedules()
            testFetchSchedule()
            testFetchThreadStations()
            testFetchNearestCity()
            testFetchCarrier()
            testFetchAllStations()
            testFetchScheduleBannersData()
        }
    }
    
    // MARK: - Helper methods
    private func testFetchStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestStationsService(
                    client: client,
                    apikey: "11ee95a9-5d01-48d4-a612-52ffa3472cc6"
                )
                
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
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = SearchService(
                    client: client,
                    apikey: "11ee95a9-5d01-48d4-a612-52ffa3472cc6"
                )
                
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
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = ScheduleService(
                    client: client,
                    apikey: "11ee95a9-5d01-48d4-a612-52ffa3472cc6"
                )
                
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
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = ThreadService(
                    client: client,
                    apikey: "11ee95a9-5d01-48d4-a612-52ffa3472cc6"
                )
                
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
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestSettlementService(
                    client: client,
                    apikey: "11ee95a9-5d01-48d4-a612-52ffa3472cc6"
                )
                
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
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CarrierService(
                    client: client,
                    apikey: "11ee95a9-5d01-48d4-a612-52ffa3472cc6"
                )
                
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
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = StationsListService(
                    client: client,
                    apikey: "11ee95a9-5d01-48d4-a612-52ffa3472cc6"
                )
                
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
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CopyrightService(
                    client: client,
                    apikey: "11ee95a9-5d01-48d4-a612-52ffa3472cc6"
                )
                
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
