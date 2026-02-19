//
//  CityStationSelectionFlowView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 10.02.2026.
//

import SwiftUI

private enum Layout {
    static let dismissAnimationDuration: CGFloat = 0.2
}

struct CityStationSelectionFlowView: View {
    private enum Route: Hashable {
        case stations(String)
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var path = NavigationPath()
    
    private let onSelectStation: (String, StationSelectionOption) -> Void
    
    init(onSelectStation: @escaping (String, StationSelectionOption) -> Void) {
        self.onSelectStation = onSelectStation
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            CitiesListView { selectedCity in
                path.append(Route.stations(selectedCity))
            }
            .customNavigationBackButton()
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .stations(let city):
                    StationsListView(city: city) { selectedStation in
                        onSelectStation(city, selectedStation)
                        withAnimation(.easeInOut(duration: Layout.dismissAnimationDuration)) {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CityStationSelectionFlowView { _, _ in }
}
