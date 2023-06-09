//
//  EpisodeModel.swift
//  Podcast
//
//  Created by aykut ipek on 12.05.2023.
//

import Foundation
import FeedKit


struct EpisodeModel: Codable{
    let title: String
    let pudDate: Date
    let description: String
    let imageUrl: String
    let streamUrl: String
    let author: String
    var fileUrl: String?
    init(value: RSSFeedItem) {
        self.author = value.iTunes?.iTunesAuthor?.description ?? value.author ?? ""
        self.title = value.title ?? ""
        self.pudDate = value.pubDate ?? Date()
        self.streamUrl = value.enclosure?.attributes?.url ?? ""
        self.description = value.iTunes?.iTunesSubtitle ?? value.description ?? ""
        self.imageUrl = value.iTunes?.iTunesImage?.attributes?.href ?? "https://cdn.pixabay.com/photo/2018/09/23/00/09/podcast-3696504_1280.jpg"
    }
}
