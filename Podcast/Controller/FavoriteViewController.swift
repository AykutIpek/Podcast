//
//  FavoriteViewController.swift
//  Podcast
//
//  Created by aykut ipek on 4.05.2023.
//

import Foundation
import UIKit

final class FavoriteViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Helpers
extension FavoriteViewController{
    private func setupUI(){
        style()
        layout()
    }
    private func style(){
        view.backgroundColor = .blue
    }
    private func layout(){
        
    }
}

