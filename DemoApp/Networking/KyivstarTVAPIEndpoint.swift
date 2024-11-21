//
//  KyivstarTVAPIEndpoint.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 15.11.2024.
//

import Foundation

// MARK: - Define of KyivstarTV API Endpoints
enum KyivstarTVAPIEndpoint: Endpoint {
    case getContentGroups
    case getPromotions
    case getCategories
    case getAssetDetails
    
    var path: String {
        switch self {
        case .getContentGroups:
            return "PGgg02gplft-"
        case .getPromotions:
            return "j_BRMrbcY-5W"
        case .getCategories:
            return "eO-fawoGqaNB"
        case .getAssetDetails:
            return "04Pl5AYhO6-n"
        }
    }
    
}
