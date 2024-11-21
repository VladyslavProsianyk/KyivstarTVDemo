//
//  HomeSectionCellModel.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 17.11.2024.
//

import Foundation

struct HomeSectionCellModel: Hashable {
    let id: String
    let title: String
    let description: String
    let image: String
    let progress: Double
    let purchased: Bool
    let type: HomeSectionCellType
    
    init(id: String, title: String = "", description: String = "", image: String, progress: Double = 0, purchased: Bool = false, type: HomeSectionCellType) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.progress = progress
        self.purchased = purchased
        self.type = type
    }
}
