//
//  ResponseDataConverter.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 19.11.2024.
//

import Foundation

protocol ResponseDataConverterProtocol {
    func convertToHomeSectionModel(from promotions: PromotionsDTO) -> HomeSectionModel
    func convertToHomeSectionModel(from categories: CategoriesDTO) -> HomeSectionModel
    func convertToHomeSectionModel(from contentGroups: [ContentGroupDTO]) -> [HomeSectionModel]
    func convertToAssetDetailsModel(from asset: AssetDetailsDTO) -> AssetDetailsModel
}

class ResponseDataConverter: ResponseDataConverterProtocol {
    func convertToHomeSectionModel(from promotionsDto: PromotionsDTO) -> HomeSectionModel {
        let data = promotionsDto.promotions.map { asset -> HomeSectionCellModel in
            return HomeSectionCellModel(
                id: asset.id,
                image: asset.image,
                type: .promotions
            )
        }
        return HomeSectionModel(
            type: .promotions,
            data: data
        )
    }
    
    func convertToHomeSectionModel(from categoriesDto: CategoriesDTO) -> HomeSectionModel {
        let data = categoriesDto.categories.map { category -> HomeSectionCellModel in
            return HomeSectionCellModel(
                id: category.id,
                title: category.name,
                image: category.image,
                type: .categories
            )
        }
        return HomeSectionModel(
            type: .categories,
            data: data
        )
    }
    
    func convertToHomeSectionModel(from contentGroupDtos: [ContentGroupDTO]) -> [HomeSectionModel] {
        var sections: [HomeSectionModel] = []
        for data in contentGroupDtos {
            var sectionType: HomeSectionType?
            switch data.type {
            case .series:
                sectionType = .cinema
            case .liveChannels:
                sectionType = .liveChannels
            case .epg:
                sectionType = .epg
            case .unknown:
                break
            }
            
            if let sectionType {
                let data = data.assets.map { asset -> HomeSectionCellModel in
                    var progress = asset.progress
                    if progress.isNaN {
                        progress = 0
                    } else if progress.isInfinite {
                        progress = 1
                    } else if 1...100 ~= progress {
                        progress = progress / 100
                    }
                    
                    return HomeSectionCellModel(
                        id: asset.id,
                        title: asset.name,
                        description: sectionType == .epg ? "У записі • Телеканал \(asset.company)" : "",
                        image: asset.image,
                        progress: progress,
                        purchased: asset.purchased,
                        type: sectionType.sectionCellType
                    )
                }
                
                if let index = sections.firstIndex(where: { $0.type == sectionType }) {
                    let element = sections[index]
                    sections[index] = element.copyWith(data: element.data + data)
                } else {
                    let sectionModel = HomeSectionModel(
                        type: sectionType,
                        data: data
                    )
                    sections.append(sectionModel)
                }
            }
        }
        return sections
    }
    
    func convertToAssetDetailsModel(from asset: AssetDetailsDTO) -> AssetDetailsModel {
        var year: Int = 0
        let dateString = asset.releaseDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            year = calendar.component(.year, from: date)
        }
        
        var duration: String {
            let seconds = Int(asset.duration)
            let hours = seconds / 3600
            let minutes = (seconds % 3600) / 60
            
            if hours > 0 {
                return "\(hours)h \(minutes)m"
            } else {
                return "\(minutes)m"
            }
        }
        
        let similarAssets = asset.similar.map { assetDto -> AssetDetailsSimilarModel in
            var progress = assetDto.progress
            if progress.isNaN {
                progress = 0
            } else if progress.isInfinite {
                progress = 1
            } else if 1...100 ~= progress {
                progress = progress / 100
            }
            return AssetDetailsSimilarModel(
                id: assetDto.id,
                image: assetDto.image,
                progress: progress,
                purchased: assetDto.purchased
            )
        }
        
        return AssetDetailsModel(
            headImage: asset.image,
            title: asset.name.isEmpty ? "Untitled" : asset.name,
            description: asset.description,
            durationText: duration,
            year: year,
            similarAssets: similarAssets
        )
    }
    
}
