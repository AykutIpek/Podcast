//
//  UserDefaultExtension.swift
//  Podcast
//
//  Created by aykut ipek on 14.05.2023.
//

import Foundation

protocol UserDefaultsInterface{
    static func downloadEpisodeWrite(episode: EpisodeModel)
    static func downloadEpisodeRead()-> [EpisodeModel]
}

extension UserDefaults: UserDefaultsInterface{
    static let downloadKey = "downloadedKey"
    //Input
    static func downloadEpisodeWrite(episode: EpisodeModel){
        do {
            var resultEpisodes = downloadEpisodeRead()
            resultEpisodes.append(episode)
            let data = try JSONEncoder().encode(resultEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadKey)
        } catch{
             
        }
    }
    //Output
    static func downloadEpisodeRead()-> [EpisodeModel]{
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.downloadKey) else { return [] }
        do {
            let resultData = try JSONDecoder().decode([EpisodeModel].self, from: data)
            return resultData
        } catch {
            
        }
        return []
    }
}
