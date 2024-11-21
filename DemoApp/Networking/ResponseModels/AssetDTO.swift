//
//  AssetDTO.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 17.11.2024.
//

import Foundation

struct AssetDTO: Decodable {
    let id: String
    let name: String
    let image: String
    let company: String
    let progress: Double
    let purchased: Bool
    let sortIndex: Int?
    let updatedAt: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case company
        case progress
        case purchased
        case sortIndex
        case updatedAt
        case releaseDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(String.self, forKey: .image)
        self.company = try container.decode(String.self, forKey: .company)
        self.progress = (try? container.decode(Double.self, forKey: .progress)) ?? 0
        self.purchased = (try? container.decode(Bool.self, forKey: .purchased)) ?? true
        self.sortIndex = try? container.decode(Int.self, forKey: .sortIndex)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
}
