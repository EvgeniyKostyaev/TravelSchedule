//
//  Story.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 15.02.2026.
//

import Foundation

struct Story: Identifiable, Hashable {
    let id: Int
    let previewImageName: String
    let fullImageName: String
    let title: String
    let description: String

    static let items: [Story] = [
        Story(
            id: 0,
            previewImageName: "Illustration_preview_1",
            fullImageName: "Illustration_1",
            title: "История 1 История 1 История 1 История 1 История 1 История 1 История 1 История 1 История 1 История 1 История 1 ",
            description: "Подборка направлений и маршрутов для путешествий. Подборка направлений и маршрутов для путешествий. Подборка направлений и маршрутов для путешествий. Подборка направлений и маршрутов для путешествий. Подборка направлений и маршрутов для путешествий"
        ),
        Story(
            id: 1,
            previewImageName: "Illustration_preview_3",
            fullImageName: "Illustration_3",
            title: "История 2",
            description: "Лучшие варианты поездок на ближайшие даты"
        ),
        Story(
            id: 2,
            previewImageName: "Illustration_preview_5",
            fullImageName: "Illustration_5",
            title: "История 3",
            description: "Планируйте пересадки и время отправления заранее"
        ),
        Story(
            id: 3,
            previewImageName: "Illustration_preview_9",
            fullImageName: "Illustration_9",
            title: "История 4",
            description: "Выбирайте перевозчика и фильтруйте результаты поиска"
        ),
        Story(
            id: 4,
            previewImageName: "Illustration_preview_17",
            fullImageName: "Illustration_17",
            title: "История 5",
            description: "Сохраните удобный маршрут и возвращайтесь к нему позже"
        )
    ]
}
