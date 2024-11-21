//
//  CategoriesCell.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 21.11.2024.
//

import UIKit
import SnapKit

class CategoriesCell: UICollectionViewCell, HomeSectionCellProtocol {
    
    var type: HomeSectionCellType {
        .categories
    }
    
    // MARK: - UI Elements
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
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
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(type.imageSize.height)
            if type.imageSize.width.isFinite {
                make.width.equalTo(type.imageSize.width)
            } else {
                make.trailing.equalToSuperview()
            } // Adjust height as needed
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func downloadImage(from urlString: String) {
        activityIndicator.startAnimating()
        ImageDownloader.shared.downloadImage(from: urlString) {[weak self] result in
            DispatchQueue.main.async {[weak self] in
                guard let self else { return }
                activityIndicator.stopAnimating()
                switch result {
                case .success(let image):
                    imageView.image = image
                case .failure:
                    imageView.image = UIImage(named: "image_not_found_file")
                }
            }
        }
    }
    
    // MARK: - Configure Cell
    func configure(with model: HomeSectionCellModel) {
        // Update image
        downloadImage(from: model.image)
        imageView.layer.cornerRadius = type.imageRadius
        
        // Update text
        titleLabel.text = model.title
    }
}
