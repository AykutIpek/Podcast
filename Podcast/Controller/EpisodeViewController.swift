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
    func configureTableView()
    func fetchData()
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

// MARK: - Helpers
extension EpisodeViewController: EpisodeViewControllerProtocol{
    func setupUI() {
        configureTableView()
        fetchData()
    }
    
    func configureTableView() {
        self.navigationItem.title = podcast.trackName
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    func fetchData() {
        EpisodeService.fetchData(urlString: self.podcast.feedUrl!) { result in
            DispatchQueue.main.async {
                self.episodeResult = result
            }
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
