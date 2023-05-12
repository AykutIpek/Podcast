//
//  EpisodeService.swift
//  Podcast
//
//  Created by aykut ipek on 7.05.2023.
//

import Foundation
import FeedKit

protocol EpisodeServiceProtocol {
    static func fetchData(urlString: String, completion: @escaping([EpisodeModel])->Void)
}

struct EpisodeService: EpisodeServiceProtocol {
    static func fetchData(urlString: String, completion: @escaping([EpisodeModel])->Void){
        var episodeResult: [EpisodeModel] = []
        let feedKit = FeedParser(URL: URL(string: urlString)!)
        feedKit.parseAsync { result in
            switch result{
            case .success(let feed):
                switch feed{
                    
                case .atom(_):
                    break
                case .rss(let feedResult):
                    feedResult.items?.forEach({ value in
                        let episodeCell = EpisodeModel(value: value)
                        episodeResult.append(episodeCell)
                        completion(episodeResult)
                    })
                case .json(_):
                    break
                }
                case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
