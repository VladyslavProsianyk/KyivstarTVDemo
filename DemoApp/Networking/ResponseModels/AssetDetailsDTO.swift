//
//  AssetDetailsDTO.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 17.11.2024.
//

import Foundation

struct AssetDetailsDTO: Decodable {
    let id: String
    let name: String
    let image: String
    let company: String
    let similar: [AssetDTO]
    let duration: Double
    let progress: Double
    let purchased: Bool
    let updatedAt: String
    let description: String
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case company
        case similar
        case duration
        case progress
        case purchased
        case updatedAt
        case description
        case releaseDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(String.self, forKey: .image)
        self.company = try container.decode(String.self, forKey: .company)
        self.similar = try container.decode([AssetDTO].self, forKey: .similar)
        self.duration = try container.decode(Double.self, forKey: .duration)
        self.progress = try container.decode(Double.self, forKey: .progress)
        self.purchased = try container.decode(Bool.self, forKey: .purchased)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.description = try container.decode(String.self, forKey: .description)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
}
