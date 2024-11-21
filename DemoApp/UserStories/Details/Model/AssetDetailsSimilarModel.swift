//
//  AssetDetailsSimilarModel.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 20.11.2024.
//

import Foundation

struct AssetDetailsSimilarModel {
    let id: String
    let image: String
    let progress: Double
    let purchased: Bool
}

extension AssetDetailsSimilarModel {
    static let mockList: [AssetDetailsSimilarModel] = [
        AssetDetailsSimilarModel(
            id: "1",
            image: "https://picsum.photos/id/861/400/600",
            progress: 33.0 / 100.0,
            purchased: false
        ),
        AssetDetailsSimilarModel(
            id: "2",
            image: "https://picsum.photos/id/574/400/600",
            progress: 0.43,
            purchased: true
        ),
        AssetDetailsSimilarModel(
            id: "3",
            image: "https://picsum.photos/id/861/400/600",
            progress: 0.0,
            purchased: false
        ),
        AssetDetailsSimilarModel(
            id: "4",
            image: "https://picsum.photos/id/574/400/600",
            progress: 0.43,
            purchased: true
        ),
        AssetDetailsSimilarModel(
            id: "5",
            image: "https://picsum.photos/id/861/400/600",
            progress: 0.0,
            purchased: false
        ),
        AssetDetailsSimilarModel(
            id: "6",
            image: "https://picsum.photos/id/574/400/600",
            progress: 0.43,
            purchased: true
        ),
        AssetDetailsSimilarModel(
            id: "7",
            image: "https://picsum.photos/id/861/400/600",
            progress: 0.0,
            purchased: false
        ),
        AssetDetailsSimilarModel(
            id: "8",
            image: "https://picsum.photos/id/574/400/600",
            progress: 0.43,
            purchased: true
        ),
        AssetDetailsSimilarModel(
            id: "9",
            image: "https://picsum.photos/id/861/400/600",
            progress: 0.0,
            purchased: false
        ),
        AssetDetailsSimilarModel(
            id: "10",
            image: "https://picsum.photos/id/574/400/600",
            progress: 0.43,
            purchased: true
        ),
        AssetDetailsSimilarModel(
            id: "11",
            image: "https://picsum.photos/id/861/400/600",
            progress: 0.0,
            purchased: false
        ),
        AssetDetailsSimilarModel(
            id: "12",
            image: "https://picsum.photos/id/574/400/600",
            progress: 0.43,
            purchased: true
        )
    ]
}
