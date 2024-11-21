//
//  SectionHeaderView.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 19.11.2024.
//

import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"
    
    private var deleteButtonAction: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var delButton: UIButton = {
        let button = UIButton()
        button.setTitle("Del", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(delButton)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        delButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, onDelete: @escaping () -> Void) {
        titleLabel.text = title
        delButton.addTarget(self, action: #selector(onTapAction), for: .touchUpInside)
        deleteButtonAction = onDelete
    }
    
    @objc private func onTapAction() {
        deleteButtonAction?()
    }
}
