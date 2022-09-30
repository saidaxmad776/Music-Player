//
//  SearchInteractor.swift
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

protocol SearchBusinessLogic
{
    func doSomething(request: Search.Something.Request.RequestType)
}

protocol SearchDataStore {
  //var name: String { get set }
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore {
    var networkService = NetworkService()
  var presenter: SearchPresentationLogic?
  var worker: SearchWorker?
  //var name: String = ""
  
  // MARK: Do something
  
    func doSomething(request: Search.Something.Request.RequestType) {
        if worker == nil {
            worker = SearchWorker()
        }
      
      switch request {

      case .getTracks(let searchTerm):
          print("iteractor")
          presenter?.presentSomething(response: Search.Something.Response.ResponceType.presnetFooterView)
          networkService.fetchTracks(searchText: searchTerm) { [weak self] (searchResponce) in
              self?.presenter?.presentSomething(response: Search.Something.Response.ResponceType.presentTracks(searchResponce: searchResponce))
          }
          
      }

    }
}
