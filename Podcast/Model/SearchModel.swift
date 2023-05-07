//
//  Search.swift
//  Podcast
//
//  Created by aykut ipek on 4.05.2023.
//

import Foundation

// MARK: - PostModel
struct PostModel: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
struct Podcast: Codable {
    var trackName: String?
    var artistName: String
    var trackCount: Int?
    var artworkUrl600: String?
    var feedUrl: String?
}
