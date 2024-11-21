//
//  AssetDetailsModel.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 20.11.2024.
//

import Foundation

struct AssetDetailsModel {
    let headImage: String
    let title: String
    let description: String
    let durationText: String
    let year: Int
    let similarAssets: [AssetDetailsSimilarModel]
}

extension AssetDetailsModel {
    static let mock = AssetDetailsModel(
        headImage: "https://picsum.photos/id/565/900/600",
        title: "Untitled",
        description: "Labore occaecat aliqua est mollit. Sint consectetur aliquip laboris eu. Sint est sit aliqua do non adipisicing consequat eiusmod.",
        durationText: "48m",
        year: 1988,
        similarAssets: AssetDetailsSimilarModel.mockList
    )
}
