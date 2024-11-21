//
//  HomeSectionCell.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 15.11.2024.
//

import UIKit
import SnapKit

enum HomeSectionCellType: Hashable {
    case promotions
    case categories
    case cinema
    case liveChannels
    case epg
    
    var reuseIdentifier: String {
        return switch self {
        case .promotions: "PromotionsCell"
        case .categories: "CategoriesCell"
        case .cinema: "CinemaCell"
        case .liveChannels: "LiveChannelsCell"
        case .epg: "EpgCell"
        }
    }

    var imageRadius: CGFloat {
        return switch self {
        case .promotions, .categories: 16
        case .cinema, .epg: 12
        case .liveChannels: imageSize.height / 2
        }
    }
    
    var isNeedDescription: Bool {
        return switch self {
        case .epg: true
        case .promotions, .cinema, .liveChannels, .categories: false
        }
    }
    
    var isNeedTitle: Bool {
        return switch self {
        case .promotions, .liveChannels: false
        case .cinema, .categories, .epg: true
        }
    }
    
    var isNeedProgress: Bool {
        return switch self {
        case .cinema, .epg: true
        case .promotions, .categories, .liveChannels: false
        }
    }
    
    var imageSize: CGSize {
        return  switch self {
        case .promotions: CGSize(width: Double.infinity, height: 180)
        case .categories: CGSize(width: 104, height: 104)
        case .cinema: CGSize(width: 104, height: 156)
        case .liveChannels: CGSize(width: 104, height: 104)
        case .epg: CGSize(width: 216, height: 120)
        }
    }
}

class HomeSectionCell: UICollectionViewCell {
    private var model: HomeSectionCellModel?
    
    private let parentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        return image
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        guard let model = model else {
            return
        }
        
        contentView.addSubview(imageView)
        imageView.addSubview(activityIndicator)
        
        if model.type.isNeedTitle {
            contentView.addSubview(titleLabel)
        }
        
        if model.type.isNeedDescription {
            contentView.addSubview(descriptionLabel)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(model.type.imageSize.height)
            make.leading.equalToSuperview()
            if model.type.imageSize.width.isFinite {
                make.width.equalTo(model.type.imageSize.width)
            } else {
                make.trailing.equalToSuperview()
            }
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        if model.type.isNeedTitle {
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottomMargin).offset(16)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                if !model.type.isNeedDescription {
                    make.bottom.equalToSuperview()
                }
            }
        }
        
        if model.type.isNeedDescription {
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        }
    }
    
    private func downloadImage(from urlString: String) {
        activityIndicator.startAnimating()
        ImageDownloader.shared.downloadImage(from: urlString) {[weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            switch result {
            case .success(let image):
                self?.imageView.image = image
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(named: "image_not_found_file")
                }
                print("Failed to download image: \(error.localizedDescription)")
            }
        }
    }
    
    private func setProgress(_ progress: Double, animated: Bool = true) {
        guard model?.type.isNeedProgress == true else { return }
        
        let clampedProgress = max(0, min(progress, 1))
        
        guard clampedProgress > 0 else { return }
        
        let progressBar: UIView = {
            let progressBar = UIView()
            progressBar.backgroundColor = .blue
            return progressBar
        }()
        
        let progressContainer: UIView = {
            let container = UIView()
            container.backgroundColor = .black
            return container
        }()
        
        imageView.addSubview(progressContainer)
        progressContainer.addSubview(progressBar)
        
        progressContainer.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(5)
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(clampedProgress)
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
    }
    
    func configure(with model: HomeSectionCellModel) {
        self.model = model
        downloadImage(from: model.image)
        imageView.layer.cornerRadius = model.type.imageRadius
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        setupUI()
        setProgress(model.progress, animated: false)
    }
}
