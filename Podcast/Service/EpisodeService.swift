//
//  EpisodeService.swift
//  Podcast
//
//  Created by aykut ipek on 7.05.2023.
//

import Foundation
import FeedKit
import Alamofire

protocol EpisodeServiceProtocol {
    static func fetchData(urlString: String, completion: @escaping([EpisodeModel])->Void)
    static func downlaodEpisode(episode: EpisodeModel)
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
    
    static func downlaodEpisode(episode: EpisodeModel) {
        let downloadrequest = DownloadRequest.suggestedDownloadDestination()
        AF.download(episode.streamUrl, to: downloadrequest).downloadProgress { progress in
            let progressValue = progress.fractionCompleted
            NotificationCenter.default.post(name: .downloadNotificationName, object: nil,userInfo: ["title": episode.title, "progress": progressValue])
        }.response { response in
            var downloadEpisodeResponse = UserDefaults.downloadEpisodeRead()
            let index = downloadEpisodeResponse.firstIndex(where: {$0.author == episode.author && $0.streamUrl == episode.streamUrl})
            downloadEpisodeResponse[index!].fileUrl = response.fileURL?.absoluteString
            do{
                let data = try JSONEncoder().encode(downloadEpisodeResponse)
                UserDefaults.standard.set(data, forKey: UserDefaults.downloadKey)
            }catch{
                
            }
        }
    }
}
