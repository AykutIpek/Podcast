//
//  FavoriteCell.swift
//  Podcast
//
//  Created by aykut ipek on 14.05.2023.
//

import Foundation
import UIKit

final class FavoriteCell: UICollectionViewCell {
    // MARK: - Properties
    private let podcastImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.customMode()
        imageView.backgroundColor = .systemPurple
        return imageView
    }()
    private let podcastNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Podcast Name"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .label
        return label
    }()
    private let podcastArtistNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Podcast Artist Name"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    private var fullStackView: UIStackView!
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension FavoriteCell{
    private func setupUI(){
        style()
        layout()
    }
    private func style(){
        fullStackView = UIStackView(arrangedSubviews: [podcastImageView, podcastNameLabel, podcastArtistNameLabel])
        fullStackView.axis = .vertical
    }
    private func layout(){
        addSubview(fullStackView)
        
        fullStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        podcastImageView.snp.makeConstraints { make in
            make.height.equalTo(podcastImageView.snp.width)
        }
    }
}

