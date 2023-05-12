//
//  EpisodeModel.swift
//  Podcast
//
//  Created by aykut ipek on 12.05.2023.
//

import Foundation
import FeedKit


struct EpisodeModel{
    let title: String
    let pudDate: Date
    let description: String
    let imageUrl: String
    init(value: RSSFeedItem) {
        self.title = value.title ?? ""
        self.pudDate = value.pubDate ?? Date()
        self.description = value.description ?? ""
        self.imageUrl = value.iTunes?.iTunesImage?.attributes?.href ?? "https://cdn.pixabay.com/photo/2018/09/23/00/09/podcast-3696504_1280.jpg"
    }
}
