//
//  KyivstarTVNetworkManager.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 18.11.2024.
//

import Foundation

// MARK: - Definition of KyivstarTVNetworkManagerProtocol
protocol KyivstarTVNetworkManagerProtocol {
    func fetchPromotions() async throws -> PromotionsDTO
    func fetchContentGroups() async throws -> [ContentGroupDTO]
    func fetchCategories() async throws -> CategoriesDTO
    func fetchAssetDetails() async throws -> AssetDetailsDTO
}

// MARK: - Implementation of KyivstarTVNetworkManagerProtocol
class KyivstarTVNetworkManager: KyivstarTVNetworkManagerProtocol {
    
    private var api: APIClient
    
    init(api: APIClient = APIClient.shared) {
        self.api = api
    }
    
    func fetchPromotions() async throws -> PromotionsDTO {
        return try await api.request(endpoint: KyivstarTVAPIEndpoint.getPromotions, responseType: PromotionsDTO.self)
    }
    
    func fetchContentGroups() async throws -> [ContentGroupDTO] {
        return try await api.request(endpoint: KyivstarTVAPIEndpoint.getContentGroups, responseType: [ContentGroupDTO].self)
    }
    
    func fetchCategories() async throws -> CategoriesDTO {
        return try await api.request(endpoint: KyivstarTVAPIEndpoint.getCategories, responseType: CategoriesDTO.self)
    }
    
    func fetchAssetDetails() async throws -> AssetDetailsDTO {
        return try await api.request(endpoint: KyivstarTVAPIEndpoint.getAssetDetails, responseType: AssetDetailsDTO.self)
    }
}
