//
//  PromotionsDTO.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 15.11.2024.
//

import Foundation

struct PromotionsDTO: Decodable {
    let id: String
    let name: String
    let promotions: [AssetDTO]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case promotions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.promotions = try container.decode([AssetDTO].self, forKey: .promotions)
    }
}
