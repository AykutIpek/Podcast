//
//  SearchViewController.swift
//  Podcast
//
//  Created by aykut ipek on 4.05.2023.
//

import Foundation
import UIKit
import Alamofire

protocol SearchViewControllerProtocol{
    func setupUI()
    func tableViewStyle()
    func configureSearchBar()
}

protocol TableViewDelegateAndDatasoure: UITableViewDelegate, UITableViewDataSource{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

protocol TableViewSearchBarDelegateProtocol: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
}


private let reuseIdentifier = "SearchCell"
final class SearchViewController: UITableViewController {
    // MARK: - Properties
    var searchResult: [Podcast] = []{
        didSet{ tableView.reloadData() }
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Helpers
extension SearchViewController: SearchViewControllerProtocol{
    func setupUI() {
        tableViewStyle()
        configureSearchBar()
    }
    
    func tableViewStyle() {
        tableView.register(SearchViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 130
    }

    func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
}

//MARK: - TableViewDelegateAndDatasoure
extension SearchViewController: TableViewDelegateAndDatasoure{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchViewCell
        cell.result = self.searchResult[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "..."
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title1)
//        label.textColor = .label
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.searchResult.count == 0 ? 80: 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = self.searchResult[indexPath.item]
        let controller = EpisodeViewController(podcast: podcast)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: TableViewSearchBarDelegateProtocol{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SearchService.fetchData(searchText: searchText) { result in
            self.searchResult = result
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchResult = []
    }
}
