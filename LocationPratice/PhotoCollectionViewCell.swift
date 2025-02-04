//
//  PhotoCollectionViewCell.swift
//  LocationPratice
//
//  Created by 권우석 on 2/4/25.
//

import UIKit
import SnapKit
class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let id = "PhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
}
