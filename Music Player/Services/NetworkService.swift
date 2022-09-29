//
//  NetworkService.swift
//  Music Player
//
//  Created by Saidaxmad on 29/09/22.
//

import Foundation
import Alamofire


class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping(SearchResponce?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parametrs = ["term":"\(searchText)",
                         "limit":"10",
                         "media":"music"]
        AF.request(url, method: .get, parameters: parametrs, encoding: URLEncoding.default, headers: nil).responseData { (dataResponce) in
            if let error = dataResponce.error {
                print("ok:\(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = dataResponce.data else { return }
            
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponce.self, from: data)
                print("objects", objects)
                completion(objects)
                
            } catch let jsonError {
                print("Failed", jsonError)
                completion(nil)
            }
            
//            let someString = String(data: data, encoding: .utf8)
//            print(someString ?? "")

        }
    }
}
