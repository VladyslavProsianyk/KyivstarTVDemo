//
//  HomeSection.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 17.11.2024.
//

import Foundation

enum HomeSectionType: Hashable {
    case promotions
    case categories
    case cinema
    case liveChannels
    case epg
    
    var sectionName: String {
        switch self {
        case .promotions:
            return ""
        case .categories:
            return "Категорії:"
        case .cinema:
            return "Новинки Київстар ТБ"
        case .liveChannels:
            return "Дитячі телеканали"
        case .epg:
            return "Пізнавальні"
        }
    }
    
    var sectionCellType: HomeSectionCellType {
        switch self {
        case .promotions:
            return .promotions
        case .categories:
            return .categories
        case .cinema:
            return .cinema
        case .liveChannels:
            return .liveChannels
        case .epg:
            return .epg
        }
    }
    
    var sortIndex: Int {
        switch self {
        case .promotions:
            return 0
        case .categories:
            return 1
        case .cinema:
            return 2
        case .liveChannels:
            return 3
        case .epg:
            return 4
        }
    }
}
