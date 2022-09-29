//
//  SearchModels.swift
//  Music Player
//
//  Created by Saidaxmad on 29/09/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Search {
    // MARK: Use cases
    
    enum Something {
        struct Request {
            enum RequestType {
                case some
                case getTracks(searchTerm: String)
            }
        }
        
        struct Response {
            enum ResponceType {
                case some
                case presentTracks(searchResponce: SearchResponce?)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case some
                case displayTacks(searchViewModel: SearchViewModel)
            }
        }
    }
}

struct SearchViewModel {
    struct Cell {
        var iconUrlString: String?
        var trackName: String
        var collectionName: String
        var artistName: String
    }
    let cells: [Cell]
}
