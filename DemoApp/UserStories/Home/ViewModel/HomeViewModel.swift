//
//  HomeViewModel.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 17.11.2024.
//

import Foundation
import Combine

final class HomeViewModel {
    @Published private var sections: [HomeSectionModel] = []
    @Published private(set) var visualSections: [HomeSectionModel] = []
    @Published private(set) var isLoading: Bool = false
        
    private(set) var errorPublisher = PassthroughSubject<String, Never>()
    
    var subscriptions: Set<AnyCancellable> = []

    private let networkService: KyivstarTVNetworkManagerProtocol
    private let responseConverter: ResponseDataConverterProtocol
    private weak var coordinator: CoordinatorProtocol?

    init(coordinator: CoordinatorProtocol,
         networkService: KyivstarTVNetworkManagerProtocol = KyivstarTVNetworkManager(),
         responseConverter: ResponseDataConverterProtocol = ResponseDataConverter()) {
        self.coordinator = coordinator
        self.networkService = networkService
        self.responseConverter = responseConverter
        
        setupBindings()
    }

    private func setupBindings() {
        $sections
            .delay(for: 0.5, scheduler: DispatchQueue.main)
            .map { $0.filter { !$0.isHiden } }
            .assign(to: &$visualSections)
    }
    
    @MainActor
    func fetchSections() async {
        isLoading = true
        
        do {
            let promotionsResponse = try await networkService.fetchPromotions()
            let categoriesResponse = try await networkService.fetchCategories()
            let contentGroupsResponse = try await networkService.fetchContentGroups()
            
            let promotionSections = responseConverter.convertToHomeSectionModel(from: promotionsResponse)
            let categorySections = responseConverter.convertToHomeSectionModel(from: categoriesResponse)
            let contentGroupSections = responseConverter.convertToHomeSectionModel(from: contentGroupsResponse)

            let sections = [promotionSections, categorySections] + contentGroupSections
            self.sections = sections.sorted(by: { $0.type.sortIndex < $1.type.sortIndex })
        } catch {
            errorPublisher.send("Failed to load sections: \(error.localizedDescription)")
            print("did receive error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func hideSection(for section: HomeSectionType) {
        guard let index = sections.firstIndex(where: { $0.type == section }) else {
            return
        }
        let sectionToHide = sections[index]
        sections[index] = sectionToHide.copyWith(isHiden: true)
    }
    
    func presentDetails(for asset: HomeSectionCellModel) {
        coordinator?.showDetails()
    }
}
