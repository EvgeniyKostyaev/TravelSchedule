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
    
    @Published private(set) var isCitiesPresenting: Bool = false
    @Published private(set) var isCarriersPresented: Bool = false
    @Published private(set) var isStoriesPresented: Bool = false
    @Published private(set) var viewedStoryIDs: Set<Int> = []
    @Published private(set) var fromText: String = String()
    @Published private(set) var toText: String = String()
    @Published private(set) var fromCode: String = String()
    @Published private(set) var toCode: String = String()
    @Published private(set) var activeState: ActiveState?
    @Published private(set) var selectedStoryIndex: Int = 0
    
    func onShowStories(index: Int) {
        self.selectedStoryIndex = index
        self.isStoriesPresented = true
    }
    
    func onHideStories() {
        isStoriesPresented = false
    }
    
    func onShowCities(activeState: ActiveState) {
        self.activeState = activeState
        isCitiesPresenting = true
    }
    
    func onHideCities() {
        isCitiesPresenting = false
        activeState = nil
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
        switch activeState {
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
    
    func onUpdateCitiesPresenting(isCitiesPresenting: Bool) {
        self.isCitiesPresenting = isCitiesPresenting
    }
    
    func onUpdateCarriersPresented(isCarriersPresented: Bool) {
        self.isCarriersPresented = isCarriersPresented
    }
    
    func onUpdateStoriesPresented(isStoriesPresented: Bool) {
        self.isStoriesPresented = isStoriesPresented
    }
    
    func onUpdateViewedStoryIDs(viewedStoryIDs: Set<Int>) {
        self.viewedStoryIDs = viewedStoryIDs
    }
}
