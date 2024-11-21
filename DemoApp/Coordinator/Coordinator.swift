//
//  RootCoordinator.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 15.11.2024.
//

import Foundation
import UIKit
import SwiftUI

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    func start(animated: Bool)
    func showDetails()
}

extension CoordinatorProtocol {
    func popViewController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
}

final class Coordinator: NSObject, CoordinatorProtocol {
    var navigationController: UINavigationController
    
    private let networkService: KyivstarTVNetworkManagerProtocol
    private let responseConverter: ResponseDataConverterProtocol
    
    init(
        navigationController: UINavigationController,
        networkService: KyivstarTVNetworkManagerProtocol = KyivstarTVNetworkManager(),
        responseConverter: ResponseDataConverterProtocol = ResponseDataConverter()
    ) {
        self.navigationController = navigationController
        self.networkService = networkService
        self.responseConverter = responseConverter
    }
    
    func start(animated: Bool) {
        let homeViewModel = HomeViewModel(coordinator: self, networkService: networkService, responseConverter: responseConverter)
        let homeViewController = HomeView(viewModel: homeViewModel)
        navigationController.pushViewController(homeViewController, animated: animated)
    }
    
    func showDetails() {
        let detailsViewModel = DetailsViewModel(coordinator: self, networkManager: networkService, responseConverter: responseConverter)
        let detailsSwiftUIView = DetailsView(viewModel: detailsViewModel)
        let detailsUIKitViewController = UIHostingController(rootView: detailsSwiftUIView)
        navigationController.pushViewController(detailsUIKitViewController, animated: true)
    }
}
