//
//  EpisodeCellViewModel.swift
//  Podcast
//
//  Created by aykut ipek on 12.05.2023.
//

import Foundation

struct EpisodeCellViewModel {
    let episode: EpisodeModel!
    
    init(episode: EpisodeModel!) {
        self.episode = episode
    }
    
    var profileImageUrl: URL?{
        return URL(string: episode.imageUrl)
    }
    
    var title: String?{
        return episode.title
    }
    
    var description: String?{
        return episode.description
    }
    
    var pubDate: String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyy"
        return dateFormatter.string(from: episode.pudDate)
    }
}
