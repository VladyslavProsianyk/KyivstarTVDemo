//
//  EPGCell.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 21.11.2024.
//

import UIKit
import SnapKit

class EPGCell: UICollectionViewCell, HomeSectionCellProtocol {
    
    var type: HomeSectionCellType {
        .epg
    }
    
    // MARK: - UI Elements
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.backgroundColor = .black
        progressView.trackTintColor = .clear
        progressView.progressTintColor = .blue
        progressView.progress = 0.0
        progressView.clipsToBounds = true
        progressView.subviews[1].clipsToBounds = true
        progressView.isHidden = true
        return progressView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var lockImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: type.lockImageName)
        return image
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
        contentView.addSubview(lockImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        imageView.addSubview(progressBar)
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
        
        lockImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(imageView).offset(type.lockImageOffset)
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(imageView)
            make.height.equalTo(5)
        }
           
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
        descriptionLabel.text = model.description
        
        // Update views visibility
        lockImageView.isHidden = model.purchased
        guard model.progress > 0 else { return}
        progressBar.isHidden = false
        progressBar.setProgress(Float(model.progress), animated: false)
    }
}
