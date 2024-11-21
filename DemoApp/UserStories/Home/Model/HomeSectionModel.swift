//
//  HomeSectionModel.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 17.11.2024.
//

import Foundation

struct HomeSectionModel: Hashable {
    let type: HomeSectionType
    let data: [HomeSectionCellModel]
    let isHiden: Bool
    let isCanHide: Bool
    
    init(type: HomeSectionType, data: [HomeSectionCellModel], isHiden: Bool = false, isCanHide: Bool = false) {
        self.type = type
        self.data = data
        self.isHiden = isHiden
        self.isCanHide = isCanHide
    }
    
    func copyWith(type: HomeSectionType? = nil,
                  data: [HomeSectionCellModel]? = nil,
                  isHiden: Bool? = nil,
                  isCanHide: Bool? = nil) -> HomeSectionModel {
        return HomeSectionModel(type: type ?? self.type,
                                data: data ?? self.data,
                                isHiden: isHiden ?? self.isHiden,
                                isCanHide: isCanHide ?? self.isCanHide)
    }
}
