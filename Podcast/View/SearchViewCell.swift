//
//  SearchViewCell.swift
//  Podcast
//
//  Created by aykut ipek on 4.05.2023.
//
import UIKit
import SnapKit
import Kingfisher


final class SearchViewCell: UITableViewCell {
    //MARK: - Properties
    var result: Podcast?{
        didSet { configure() }
    }
    //MARK: - UIElements
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemPurple
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 13
        return imageView
    }()
    private let trackName: UILabel = {
        let label = UILabel()
        label.text = "trackName"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    private let artistName: UILabel = {
        let label = UILabel()
        label.text = "artistName"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private let trackCount: UILabel = {
        let label = UILabel()
        label.text = "trackCount"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var stackView: UIStackView!
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension SearchViewCell{
    private func setupUI(){
        configureStackView()
        layout()
    }
    private func configure(){
        guard let result = self.result else { return }
        let viewModel = SearchViewModel(podcast: result)
        trackName.text = viewModel.trackName
        trackCount.text = viewModel.trackCountString
        artistName.text = viewModel.artistName
        photoImageView.kf.setImage(with: viewModel.photoImageUrl)
    }
    
    private func configureStackView(){
        stackView = UIStackView(arrangedSubviews: [trackName,artistName,trackCount])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
    }
    private func layout(){
        addSubview(photoImageView)
        addSubview(stackView)
        photoImageView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(80)
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(photoImageView.snp.centerY)
            make.left.equalTo(photoImageView.snp.right).offset(8)
            make.right.equalToSuperview()
        }
    }
}
