//
//  HomeSectionCellType.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 15.11.2024.
//

import UIKit
import SnapKit

enum HomeSectionCellType: Hashable {
    case promotions
    case categories
    case cinema
    case liveChannels
    case epg
    
    var reuseIdentifier: String {
        return switch self {
        case .promotions: "PromotionsCell"
        case .categories: "CategoriesCell"
        case .cinema: "CinemaCell"
        case .liveChannels: "LiveChannelsCell"
        case .epg: "EpgCell"
        }
    }

    var imageRadius: CGFloat {
        return switch self {
        case .promotions, .categories: 16
        case .cinema, .epg: 12
        case .liveChannels: imageSize.height / 2
        }
    }
    
    var isNeedDescription: Bool {
        return switch self {
        case .epg: true
        case .promotions, .cinema, .liveChannels, .categories: false
        }
    }
    
    var isNeedTitle: Bool {
        return switch self {
        case .promotions, .liveChannels: false
        case .cinema, .categories, .epg: true
        }
    }
    
    var isNeedProgress: Bool {
        return switch self {
        case .cinema, .epg: true
        case .promotions, .categories, .liveChannels: false
        }
    }
    
    var lockImageName: String {
        return switch self {
        case .cinema, .epg: "lock_in_circle_small_icon"
        case .liveChannels: "lock_in_circle_normal_icon"
        case .promotions, .categories: ""
        }
    }
    
    var lockImageOffset: CGFloat {
        return switch self {
        case .cinema, .epg: 8
        case .liveChannels, .promotions, .categories: 0
        }
    }
    
    var imageSize: CGSize {
        return  switch self {
        case .promotions: CGSize(width: Double.infinity, height: 180)
        case .categories: CGSize(width: 104, height: 104)
        case .cinema: CGSize(width: 104, height: 156)
        case .liveChannels: CGSize(width: 104, height: 104)
        case .epg: CGSize(width: 216, height: 120)
        }
    }
}

protocol HomeSectionCellProtocol {
    func configure(with model: HomeSectionCellModel)
}
 
