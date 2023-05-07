//
//  PodcastTableView.swift
//  Podcast
//
//  Created by aykut ipek on 4.05.2023.
//

import Foundation
import UIKit

//MARK: - Input
protocol PodcastTableViewProtocol{
    func updates(items: [PostModel])
}

//MARK: - Output
protocol PodcastTableViewOutput: AnyObject{
    func onSelected(item: PostModel)
}

final class PodcastTableView: NSObject {
    private lazy var items: [PostModel] = []
    weak var delegate: PodcastTableViewOutput?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onSelected(item: items[indexPath.row])
    }
}

// MARK: - Helpers
extension PodcastTableView: UITableViewDelegate, UITableViewDataSource{}
extension PodcastTableView: PodcastTableViewProtocol{
    func updates(items: [PostModel]) {
        print(items)
    }
    
    
}

