//
//  Extension.swift
//  Podcast
//
//  Created by aykut ipek on 7.05.2023.
//

import Foundation
import UIKit

extension UIImageView{
    func customMode(){
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}
