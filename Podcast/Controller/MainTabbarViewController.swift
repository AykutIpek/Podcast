//
//  MainTabbarViewController.swift
//  Podcast
//
//  Created by aykut ipek on 4.05.2023.
//

import Foundation
import UIKit
import SnapKit

protocol MainTabbarControllerProtocol{
    func style()
    func createViewController(rootViewController: UIViewController, title: String, imageName: String)-> UINavigationController
}

final class MainTabbarViewController: UITabBarController {
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
}

// MARK: - Helpers
extension MainTabbarViewController: MainTabbarControllerProtocol{
    func style() {
        viewControllers = [
            createViewController(rootViewController: FavoriteViewController(), title: "Favorites", imageName: "house.fill"),
            createViewController(rootViewController: SearchViewController(), title: "Search", imageName: "magnifyingglass"),
            createViewController(rootViewController: DownloadsViewController(), title: "Downloads", imageName: "square.stack.fill")
        ]
    }
    
    func createViewController(rootViewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        rootViewController.title = title
        let controller = UINavigationController(rootViewController: rootViewController)
        let apperance = UINavigationBarAppearance()
        apperance.configureWithDefaultBackground()
        controller.navigationBar.prefersLargeTitles = true
        controller.navigationBar.compactAppearance = apperance
        controller.navigationBar.standardAppearance = apperance
        controller.navigationBar.scrollEdgeAppearance = apperance
        controller.navigationBar.compactAppearance = apperance
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(systemName: imageName)
        return controller
    }
}

