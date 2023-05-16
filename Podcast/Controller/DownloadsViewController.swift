//
//  DownloadsViewController.swift
//  Podcast
//
//  Created by aykut ipek on 4.05.2023.
//

import Foundation
import UIKit


protocol DownloadsViewControllerInterface {
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func setupUI()
    func style()
    func setNotificationCenter()
}


private let reuseIdentifier = "DownloadCell"
final class DownloadsViewController: UITableViewController {
    // MARK: - Properties
    private var episodeResult = UserDefaults.downloadEpisodeRead()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.episodeResult = UserDefaults.downloadEpisodeRead()
        tableView.reloadData()
        let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let mainTabController = window.keyWindow?.rootViewController as! MainTabbarViewController
        mainTabController.viewControllers?[2].tabBarItem.badgeValue = nil
    }
}

// MARK: - Selector
extension DownloadsViewController{
    @objc private func handleDownload(notification: Notification){
        guard let response = notification.userInfo as? [String: Any] else { return }
        guard let title = response["title"] as? String else { return }
        guard let progressValue = response["progress"] as? Double else { return }
        guard let index = self.episodeResult.firstIndex(where: {$0.title == title}) else {return}
        guard let cell = self.tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? EpisodeCell else { return}
        cell.progressView.isHidden = false
        cell.progressView.setProgress(Float(progressValue), animated: true)
        if progressValue >= 1{
            cell.progressView.isHidden = true
        }
    }
}

// MARK: - Helpers
extension DownloadsViewController: DownloadsViewControllerInterface{
    func setupUI(){
        style()
        setNotificationCenter()
    }
    func style(){
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    func setNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownload), name: .downloadNotificationName, object: nil)
    }
}

// MARK: - UITableViewDataSource
extension DownloadsViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeResult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EpisodeCell
        cell.episode = episodeResult[indexPath.item]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DownloadsViewController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = PlayerViewController(episode: self.episodeResult[indexPath.item])
        self.present(controller, animated: true)
    }
}

