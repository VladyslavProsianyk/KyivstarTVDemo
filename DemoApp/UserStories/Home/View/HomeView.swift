//
//  HomeView.swift
//  DemoApp
//
//  Created by Pete Shpagin on 31.03.2021.
//

import UIKit
import Toast
import SnapKit

class HomeView: UIViewController, UICollectionViewDelegate {
    
    private var viewModel: HomeViewModel
    
    private var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kyivstar_tv_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<HomeSectionType, HomeSectionCellModel>!
    
    private let topLabelIcon: UINavigationItem = {
        let title = UINavigationItem()
        title.title = "Home"
        return title
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setupTopImageView()
        setupCollectionView()
        setupDataSource()
        applySnapshot()
        setupBindings()
        Task {
            await viewModel.fetchSections()
        }
    }
    
    private func setupBindings() {
        viewModel.$visualSections
            .receive(on: DispatchQueue.main)
            .sink {[weak self] sections in
                self?.applySnapshot()
                self?.collectionView.reloadData()
            }
            .store(in: &viewModel.subscriptions)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink {[weak self] isLoading in
                if isLoading {
                    self?.view.makeToastActivity(.center)
                } else {
                    self?.view.hideToastActivity()
                }
            }
            .store(in: &viewModel.subscriptions)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] errorMessage in
                if self?.view.isShowingToast() == true {
                    self?.view.hideToast()
                }
                self?.view.makeToast(errorMessage, duration: 3, completion: {[weak self] didTap in
                    if didTap {
                        self?.view.hideToast()
                    }
                })
            }
            .store(in: &viewModel.subscriptions)
    }
    
    private func setupCollectionView() {
        
        collectionView.register(HomeSectionCell.self, forCellWithReuseIdentifier: HomeSectionCellType.promotions.reuseIdentifier)
        collectionView.register(HomeSectionCell.self, forCellWithReuseIdentifier: HomeSectionCellType.categories.reuseIdentifier)
        collectionView.register(HomeSectionCell.self, forCellWithReuseIdentifier: HomeSectionCellType.cinema.reuseIdentifier)
        collectionView.register(HomeSectionCell.self, forCellWithReuseIdentifier: HomeSectionCellType.liveChannels.reuseIdentifier)
        collectionView.register(HomeSectionCell.self, forCellWithReuseIdentifier: HomeSectionCellType.epg.reuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(topImageView.snp.bottom).offset(16)
        }
    }
    
    private func setupTopImageView() {
        view.addSubview(topImageView)
        
        topImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-8)
            make.height.equalTo(18)
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {[weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            let sectionType = viewModel.visualSections[sectionIndex].type
            switch sectionType {
            case .promotions:
                return createPagerSection()
            case .categories, .cinema, .liveChannels, .epg:
                let itemHeight = sectionType.sectionCellType.imageSize.height +
                (sectionType.sectionCellType.isNeedTitle ? 32 : 0) +
                (sectionType.sectionCellType.isNeedDescription ? 20 : 0)
                let itemWidth = sectionType.sectionCellType.imageSize.width
                return createHorizontalSection(itemHeight: itemHeight, itemWidth: itemWidth)
            }
        }
    }
    
    private func createHorizontalSection(itemHeight: CGFloat, itemWidth: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 32, trailing: 24)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(24))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createPagerSection() -> NSCollectionLayoutSection {
        let height = HomeSectionCellType.promotions.imageSize.height
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 24, bottom: 16, trailing: 24)
        
        return section
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSectionType, HomeSectionCellModel>(collectionView: collectionView) {[weak self] (collectionView, indexPath, cellModel) -> UICollectionViewCell? in
            guard let self else { return nil }
            let sectionType = viewModel.visualSections[indexPath.section].type
           
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionType.sectionCellType.reuseIdentifier, for: indexPath) as? HomeSectionCell
            
            cell?.configure(with: cellModel)
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                        for: indexPath
                    ) as? SectionHeaderView
                else {
                    return nil
                }
                
                let sectionType = self.viewModel.visualSections[indexPath.section].type
                let sectionTitle: String = sectionType.sectionName
                
                headerView.configure(with: sectionTitle, onDelete: {[weak self] in
                    guard let self else { return }
                    viewModel.hideSection(for: sectionType)
                })
                return headerView
            default:
                return nil
            }
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSectionType, HomeSectionCellModel>()
        for section in viewModel.visualSections {
            snapshot.appendSections([section.type])
            snapshot.appendItems(section.data, toSection: section.type)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = viewModel.visualSections[indexPath.section]
        let cellModel = section.data[indexPath.row]
        viewModel.presentDetails(for: cellModel)
    }
}
