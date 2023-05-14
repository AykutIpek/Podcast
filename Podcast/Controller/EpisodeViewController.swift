//
//  EpisodeViewController.swift
//  Podcast
//
//  Created by aykut ipek on 7.05.2023.
//

import Foundation
import UIKit

protocol EpisodeViewControllerProtocol{
    func setupUI()
    func setupNavbarItem()
    func configureTableView()
    func fetchData()
    func addCoreData()
    func fetchCoreData()
    func deleteCoreData()
}

protocol TableViewDelegateandDatasourceProtocol: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}

private let reuseIdentifier = "EpisodeCell"
final class EpisodeViewController: UITableViewController {
    // MARK: - Properties
    private var podcast: Podcast
    private var episodeResult: [EpisodeModel] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    private var resultCoreDataItems: [PodcastCoreData] = []{
        didSet{
            let isValue = resultCoreDataItems.contains(where: {$0.feedUrl == self.podcast.feedUrl})
            switch isValue{
            case true:
                isFavorite = true
            case false:
                isFavorite = false
            }
        }
    }
    private var isFavorite = false{
        didSet{
            setupNavbarItem()
        }
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    init(podcast: Podcast){
        self.podcast = podcast
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Selector
extension EpisodeViewController{
    @objc private func handleFavoriButton(_ sender: UIButton){
        switch isFavorite{
        case true:
            deleteCoreData()
        case false:
            addCoreData()
        }
    }
}

// MARK: - Helpers
extension EpisodeViewController: EpisodeViewControllerProtocol{
    func setupUI() {
        configureTableView()
        fetchData()
        setupNavbarItem()
        fetchCoreData()
    }
    
    func deleteCoreData() {
        CoreDataControl.deleteCoreData(array: resultCoreDataItems, podcast: self.podcast)
        self.isFavorite = false
    }
    
    func fetchCoreData() {
        let fetchRequest = PodcastCoreData.fetchRequest()
        CoreDataControl.fetchCoreData(fetchRequst: fetchRequest) { result in
            self.resultCoreDataItems = result
        }
    }
    
    func addCoreData() {
        let model = PodcastCoreData(context: context)
        CoreDataControl.addCoreData(model: model, podcast: self.podcast)
        isFavorite = true
        let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let mainTabController = window.keyWindow?.rootViewController as! MainTabbarViewController
        mainTabController.viewControllers?[0].tabBarItem.badgeValue = "New"
    }
    
    func configureTableView() {
        self.navigationItem.title = podcast.trackName
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: reuseIdentifier)
        setupNavbarItem()
        fetchCoreData()
    }
    func fetchData() {
        EpisodeService.fetchData(urlString: self.podcast.feedUrl!) { result in
            DispatchQueue.main.async {
                self.episodeResult = result
            }
        }
    }
    func setupNavbarItem() {
        switch isFavorite {
        case true:
            let navRightItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(handleFavoriButton))
            self.navigationItem.rightBarButtonItem = navRightItem
        case false:
            let navRightItem = UIBarButtonItem(image: UIImage(systemName: "heart")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(handleFavoriButton))
            self.navigationItem.rightBarButtonItem = navRightItem
        }
    }
}

extension EpisodeViewController: TableViewDelegateandDatasourceProtocol{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return episodeResult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EpisodeCell
        cell.episode = self.episodeResult[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodeResult[indexPath.item]
        let controller = PlayerViewController(episode: episode)
        self.present(controller, animated: true)
    }
}
