//
//  EpisodeCell.swift
//  Podcast
//
//  Created by aykut ipek on 7.05.2023.
//

import Foundation
import UIKit

protocol EpisodeCellProtocol{
    func setupUI()
    func style()
    func layout()
}

final class EpisodeCell: UITableViewCell {
    // MARK: - Properties
    private let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.customMode()
        imageView.backgroundColor = .systemPurple
        return imageView
    }()
    private let pudDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Title Label"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemPurple
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title Label"
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        label.textColor = .systemPurple
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Title Label"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .systemPurple
        return label
    }()
    private var stackView: UIStackView!
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension EpisodeCell: EpisodeCellProtocol{
    func setupUI(){
        style()
        layout()
    }
    func style(){
        stackView = UIStackView(arrangedSubviews: [pudDateLabel,titleLabel,descriptionLabel])
        stackView.axis = .vertical
    }
    func layout(){
        addSubview(episodeImageView)
        addSubview(stackView)
        
        episodeImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(episodeImageView.snp.centerY)
            make.left.equalTo(episodeImageView.snp.right).offset(10)
            make.right.equalToSuperview()
        }
    }
}

