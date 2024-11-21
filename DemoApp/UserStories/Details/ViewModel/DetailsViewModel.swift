//
//  DetailsViewModel.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 20.11.2024.
//

import Foundation

class DetailsViewModel: ObservableObject {
    @Published var model: AssetDetailsModel?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private let networkManager: KyivstarTVNetworkManagerProtocol
    private let responseConverter: ResponseDataConverterProtocol
    private weak var coordinator: CoordinatorProtocol?
    
    init(coordinator: CoordinatorProtocol,
         networkManager: KyivstarTVNetworkManagerProtocol = KyivstarTVNetworkManager(),
         responseConverter: ResponseDataConverterProtocol = ResponseDataConverter()
    ) {
        self.networkManager = networkManager
        self.coordinator = coordinator
        self.responseConverter = responseConverter
    }
    
    @MainActor
    func fetchDetails() async {
        isLoading = true
        error = nil
        model = nil
        do {
            let assetDetailsDto = try await networkManager.fetchAssetDetails()
            let assetDetails = responseConverter.convertToAssetDetailsModel(from: assetDetailsDto)
            model = assetDetails
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    func popBack() {
        coordinator?.popViewController(animated: true)
    }
}
