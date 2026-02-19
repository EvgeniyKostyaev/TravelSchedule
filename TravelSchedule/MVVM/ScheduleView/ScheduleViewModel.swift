//
//  ScheduleViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 19.02.2026.
//

import Foundation

@MainActor
final class ScheduleViewModel: ObservableObject {
    let stories: [Story] = Story.items
    
    @Published var isCitiesPresenting: Bool = false
    @Published var isCarriersPresented: Bool = false
    @Published var isStoriesPresented: Bool = false
    @Published var viewedStoryIDs: Set<Int> = []
    
    @Published private(set) var fromText: String = String()
    @Published private(set) var toText: String = String()
    @Published private(set) var fromCode: String = String()
    @Published private(set) var toCode: String = String()
    @Published private(set) var activeField: ActiveField?
    @Published private(set) var selectedStoryIndex: Int = 0
    
    func onShowStories(index: Int) {
        self.selectedStoryIndex = index
        self.isStoriesPresented = true
    }
    
    func onHideStories() {
        isStoriesPresented = false
    }
    
    func onShowCities(activeField: ActiveField) {
        self.activeField = activeField
        isCitiesPresenting = true
    }
    
    func onHideCities() {
        isCitiesPresenting = false
        activeField = nil
    }
    
    func onShowCarriers() {
        isCarriersPresented = true
    }
    
    func onSwapData() {
        let temp = fromText
        fromText = toText
        toText = temp

        let tempCode = fromCode
        fromCode = toCode
        toCode = tempCode
    }
    
    func onSelectData(city: String, station: StationSelectionOption) {
        let stationTitle = station.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let value: String
        if stationTitle.localizedCaseInsensitiveContains(city) {
            value = stationTitle
        } else {
            value = "\(city) (\(stationTitle))"
        }
        switch activeField {
        case .from:
            fromText = value
            fromCode = station.code
        case .to:
            toText = value
            toCode = station.code
        case .none:
            break
        }
    }
}
