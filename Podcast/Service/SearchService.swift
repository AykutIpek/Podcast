//
//  SearchService.swift
//  Podcast
//
//  Created by aykut ipek on 4.05.2023.
//

import Foundation
import Alamofire

enum ServicePath: String{
    case POSTS = "?term=jack+johnson"
}
extension ServicePath{
    func withBaseUrl()-> String{
        return "https://itunes.apple.com/search"
        
    }
}

protocol SerachServiceInterface{
    static func fetchData(searchText: String, completion: @escaping ([Podcast])-> Void)
}

struct SearchService: SerachServiceInterface{
    static func fetchData(searchText: String, completion: @escaping ([Podcast])-> Void){
        let parameters = ["media": "podcast", "term": searchText]
        AF.request(ServicePath.POSTS.withBaseUrl(), parameters: parameters).responseData { response in
            if let error = response.error {
                print(error.localizedDescription)
                return
            }
            guard let data = response.data else {return}
            do{
                let searchResult = try JSONDecoder().decode(PostModel.self,from: data)
                completion(searchResult.results)
            }catch{
                print("err")
            }
        }
    }
}
