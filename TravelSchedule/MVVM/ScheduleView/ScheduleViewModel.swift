//
//  ScheduleViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 19.02.2026.
//

import Foundation

final class ScheduleViewModel: ObservableObject {
    let stories: [Story] = Story.items
    
    @Published var fromText: String = String()
    @Published var toText: String = String()
    @Published var fromCode: String = String()
    @Published var toCode: String = String()
    @Published var activeField: ActiveField?
    @Published var isCitiesPresenting: Bool = false
    @Published var isCarriersPresented: Bool = false
    @Published var viewedStoryIDs: Set<Int> = []
    @Published var selectedStoryIndex: Int = 0
    @Published var isStoriesPresented: Bool = false
    
    
}
