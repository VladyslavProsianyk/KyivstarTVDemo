//
//  CategoriesDTO.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 19.11.2024.
//

import Foundation

struct CategoriesDTO: Decodable {
    let categories: [CategoryDTO]
    
    enum CodingKeys: String, CodingKey {
        case categories
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.categories = try container.decode([CategoryDTO].self, forKey: .categories)
    }
}

struct CategoryDTO: Decodable {
    let id: String
    let name: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(String.self, forKey: .image)
    }
}
