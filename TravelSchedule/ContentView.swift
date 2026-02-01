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
//            testFetchStations()
//            testFetchRouteSegmentSchedules()
            testFetchSchedule()
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
                
                print("Fetching stations...")
                let stations = try await service.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                
                print("Successfully fetched stations: \(stations)")
            } catch {
                
                print("Error fetching stations: \(error)")
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
                
                print("Fetching stations...")
                let schedules = try await service.getScheduleBetweenStations(from: "s9600213", to: "c146")
                
                print("Successfully fetched stations: \(schedules)")
            } catch {
                
                print("Error fetching stations: \(error)")
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
                
                print("Fetching stations...")
                let schedule = try await service.getStationSchedule(station: "s9600213")
                
                print("Successfully fetched stations: \(schedule)")
            } catch {
                
                print("Error fetching stations: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
