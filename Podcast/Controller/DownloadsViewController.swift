//
//  DownloadsViewController.swift
//  Podcast
//
//  Created by aykut ipek on 4.05.2023.
//

import Foundation
import UIKit

final class DownloadsViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Helpers
extension DownloadsViewController{
    private func setupUI(){
        style()
        layout()
    }
    private func style(){
        view.backgroundColor = .gray
    }
    private func layout(){
        
    }
}

