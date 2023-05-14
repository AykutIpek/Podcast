//
//  FavoriteViewController.swift
//  Podcast
//
//  Created by aykut ipek on 4.05.2023.
//

import Foundation
import UIKit

private let reuseIdentifier = "FavoriteCell"
final class FavoriteViewController: UICollectionViewController {
    // MARK: - Properties
    private var resultCoreDataItems: [PodcastCoreData] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    // MARK: - Life Cycle
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let mainTabController = window.keyWindow?.rootViewController as! MainTabbarViewController
        mainTabController.viewControllers?[0].tabBarItem.badgeValue = nil
        fetchData()
    }
}

// MARK: - Helpers
extension FavoriteViewController{
    private func setupUI(){
        style()
        layout()
    }
    private func fetchData(){
        let fetchRequest = PodcastCoreData.fetchRequest()
        CoreDataControl.fetchCoreData(fetchRequst: fetchRequest) { result in
            self.resultCoreDataItems = result
        }
    }
    private func style(){
        view.backgroundColor = .systemBackground
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    private func layout(){
        
    }
}

extension FavoriteViewController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.resultCoreDataItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoriteCell
        cell.podcastCoreData = self.resultCoreDataItems[indexPath.item]
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return .init(width: width, height: width + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteViewController{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let podcastCoreData = self.resultCoreDataItems[indexPath.item]
        let podcast = Podcast(trackName: podcastCoreData.trackName, artistName: podcastCoreData.artistName!, artworkUrl600: podcastCoreData.artworkUrl600, feedUrl: podcastCoreData.feedUrl)
        let controller = EpisodeViewController(podcast: podcast)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
