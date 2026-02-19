//
//  ScheduleViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 19.02.2026.
//

import Foundation

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
    
    func onShowStoriesView(selectedStoryIndex: Int) {
        self.selectedStoryIndex = selectedStoryIndex
        self.isStoriesPresented = true
    }
    
    func onHideStoriesView() {
        isStoriesPresented = false
    }
    
    func onShowCities(activeField: ActiveField) {
        self.activeField = activeField
        isCitiesPresenting = true
    }
    
    func onHideCitiesView() {
        isCitiesPresenting = false
        activeField = nil
    }
    
    func onShowCarriersView() {
        isCarriersPresented = true
    }

    func onUpdateFromData(fromText: String, fromCode: String) {
        self.fromText = fromText
        self.fromCode = fromCode
    }
    
    func onUpdateToData(toText: String, toCode: String) {
        self.toText = toText
        self.toCode = toCode
    }
    
    func onSwapFromToData() {
        let temp = fromText
        fromText = toText
        toText = temp

        let tempCode = fromCode
        fromCode = toCode
        toCode = tempCode
    }
}
