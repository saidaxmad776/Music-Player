//
//  SearchResponce.swift
//  Music Player
//
//  Created by Saidaxmad on 29/09/22.
//

import Foundation

struct SearchResponce: Decodable {
    
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
}
