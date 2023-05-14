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
    var episode: EpisodeModel?{
        didSet{
            configure()
        }
    }
    private let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.customMode()
        imageView.backgroundColor = .systemPurple
        imageView.layer.cornerRadius = 12
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
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 2
        label.textColor = .label
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Title Label"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .lightGray
        return label
    }()
    var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .lightGray
        progressView.tintColor = .systemPurple
        progressView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        progressView.layer.cornerRadius = 12
        progressView.setProgress(Float(0), animated: true)
        progressView.isHidden = true
        return progressView
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
        stackView.spacing = 5
    }
    func layout(){
        addSubview(episodeImageView)
        addSubview(stackView)
        addSubview(progressView)
        
        episodeImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(episodeImageView.snp.centerY)
            make.left.equalTo(episodeImageView.snp.right).offset(10)
            make.right.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(episodeImageView.snp.left)
            make.right.equalTo(episodeImageView.snp.right)
            make.bottom.equalTo(episodeImageView.snp.bottom)
        }
    }
    
    private func configure(){
        guard let episode = self.episode else { return }
        let viewModel = EpisodeCellViewModel(episode: episode)
        self.titleLabel.text = episode.title
        self.episodeImageView.kf.setImage(with: viewModel.profileImageUrl)
        self.titleLabel.text =  viewModel.title
        self.descriptionLabel.text = viewModel.description
        self.pudDateLabel.text = viewModel.pubDate
    }
}

