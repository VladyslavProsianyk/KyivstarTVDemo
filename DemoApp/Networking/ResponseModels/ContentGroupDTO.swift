//
//  ContentGroupDTO.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 15.11.2024.
//

import Foundation

struct ContentGroupDTO: Decodable {
    let id: String
    let name: String
    let type: ContentGroupType
    let assets: [AssetDTO]
    let hidden: Bool
    let sortIndex: Int
    let canBeDeleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case assets
        case hidden
        case sortIndex
        case canBeDeleted
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        let stringType = try container.decode([String].self, forKey: .type)
        self.type = ContentGroupType(rawValue: stringType.first ?? "")
        self.assets = try container.decode([AssetDTO].self, forKey: .assets)
        self.hidden = try container.decode(Bool.self, forKey: .hidden)
        self.sortIndex = try container.decode(Int.self, forKey: .sortIndex)
        self.canBeDeleted = try container.decode(Bool.self, forKey: .canBeDeleted)
    }
    
}

enum ContentGroupType: String, Decodable {
    case series = "SERIES"
    case liveChannels = "LIVECHANNEL"
    case epg = "EPG"
    case unknown
    
    init(rawValue: String) {
        switch rawValue {
        case ContentGroupType.series.rawValue:
            self = .series
        case ContentGroupType.liveChannels.rawValue:
            self = .liveChannels
        case ContentGroupType.epg.rawValue:
            self = .epg
        default:
            self = .unknown
        }
    }
}
