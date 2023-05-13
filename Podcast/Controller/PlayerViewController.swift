//
//  PlayerViewController.swift
//  Podcast
//
//  Created by aykut ipek on 13.05.2023.
//

import Foundation
import UIKit
import AVKit

final class PlayerViewController: UIViewController {
    // MARK: - Properties
    var episode: EpisodeModel?
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        return button
    }()
    private let episodeImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.customMode()
        imageView.backgroundColor = .systemPurple
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    private let sliderView: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(), for: .normal)
        return slider
    }()
    private let startLabel: UILabel = {
        let label = UILabel()
        label.text = "00 : 00"
        label.textAlignment = .left
        return label
    }()
    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = "00 : 00"
        label.textAlignment = .right
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private let userLabel: UILabel = {
        let label = UILabel()
        label.text = "user"
        label.textAlignment = .center
        return label
    }()
    private lazy var goForWordButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setImage(UIImage(systemName: "goforward.30"), for: .normal)
        button.addTarget(self, action: #selector(handleGoForWardButton), for: .touchUpInside)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    private lazy var goPlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.addTarget(self, action: #selector(handleGoPlayButton), for: .touchUpInside)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    private lazy var goBackWordButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setImage(UIImage(systemName: "gobackward.15"), for: .normal)
        button.addTarget(self, action: #selector(handleGoBackWardButton), for: .touchUpInside)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    private lazy var volumeSliderView: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(handleVolumeSliderView), for: .valueChanged)
        return slider
    }()
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.wave.3.fill")
        imageView.tintColor = .lightGray
        return imageView
    }()
    private let minusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.wave.1.fill")
        imageView.tintColor = .lightGray
        return imageView
    }()
    private let player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    private var timerStackView: UIStackView!
    private var volumeStackView: UIStackView!
    private var playStackView: UIStackView!
    private var mainStackView: UIStackView!
    // MARK: - Life Cycle
    init(episode: EpisodeModel) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.pause()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Selector
extension PlayerViewController{
    @objc private func handleGoPlayButton(_ sender: UIButton){
        switch player.timeControlStatus {
        case .paused:
            player.play()
            self.goPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        case .playing:
            player.pause()
            goPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        case .waitingToPlayAtSpecifiedRate:
            break
        @unknown default:
            print("Error")
        }
    }
    @objc private func handleCloseButton(_ sender: UIButton){
        player.pause()
        self.dismiss(animated: true)
    }
    @objc private func handleGoForWardButton(_ sender: UIButton){
        updateForWard(value: 30)
    }
    @objc private func handleGoBackWardButton(_ sender: UIButton){
        updateForWard(value: -15)
    }
    @objc private func handleVolumeSliderView(_ sender: UISlider){
        player.volume = sender.value
    }
}

// MARK: - Helpers
extension PlayerViewController{
    private func setupUI(){
        configureTimerStackView()
        configurePlayStackView()
        configureVolumeStackView()
        configureMainStackView()
        layout()
        startPlay()
        configureUI()
    }
    fileprivate func updateForWard(value: Int64){
        let exampleTime = CMTime(value: value, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), exampleTime)
        player.seek(to: seekTime)
    }
    fileprivate func updateSlider(){
        let currentTimeSecond = CMTimeGetSeconds(player.currentTime())
        let durationTime = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let resultSecondTime = currentTimeSecond / durationTime
        self.sliderView.value = Float(resultSecondTime)
    }
    fileprivate func updateTimeLabel(){
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            self.startLabel.text = time.formatString()
            let endTimeSecond = self.player.currentItem?.duration
            self.endLabel.text = endTimeSecond?.formatString()
            self.updateSlider()
        }
    }
    private func configureTimerStackView(){
        timerStackView = UIStackView(arrangedSubviews: [startLabel, endLabel])
        timerStackView.axis = .horizontal
    }
    private func configurePlayStackView(){
        playStackView = UIStackView(arrangedSubviews: [goBackWordButton, UIView(), goPlayButton, UIView(), goForWordButton])
        playStackView.axis = .horizontal
        playStackView.distribution = .fillEqually
    }
    private func configureVolumeStackView(){
        volumeStackView = UIStackView(arrangedSubviews: [minusImageView, volumeSliderView, plusImageView])
        volumeStackView.axis = .horizontal
    }
    private func configureMainStackView(){
        let fullTimerStackView = UIStackView(arrangedSubviews: [sliderView, timerStackView])
        fullTimerStackView.axis = .vertical
        mainStackView = UIStackView(arrangedSubviews: [closeButton, episodeImageView, fullTimerStackView, UIView(), nameLabel, userLabel, UIView(), playStackView, volumeStackView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
    }

    private func layout(){
        ///Add Subview
        view.addSubview(mainStackView)
        ///Screen Layout
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.bottom.equalTo(-16)
        }
        
        episodeImageView.snp.makeConstraints { make in
            make.height.equalTo(view.snp.width).multipliedBy(0.8)
        }
        
        sliderView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(20)
        }
        
        playStackView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    private func startPlay(){
        guard let url = URL(string: episode!.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        self.goPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        self.volumeSliderView.value = 40
        updateTimeLabel()
    }
    
    private func configureUI(){
        self.episodeImageView.kf.setImage(with: URL(string: episode?.imageUrl ?? ""))
        self.nameLabel.text = episode?.title
        self.userLabel.text = episode?.author
    }
}

