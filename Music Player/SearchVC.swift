//
//  SearchViewController.swift
//  Music Player
//
//  Created by Saidaxmad on 28/09/22.
//

import UIKit
import Alamofire


//struct TrackModel {
//    var trackName: String
//    var artistName: String
//}

class SearchVC: UITableViewController {
    
    var networkService = NetworkService()
    private var timer: Timer?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var arrayTrack = [Track]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupSearchBar()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayTrack.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let track = arrayTrack[indexPath.row]
        cell.textLabel?.text = "\(track.trackName) - \(track.artistName)"
        cell.imageView?.image = #imageLiteral(resourceName: "search")
        cell.textLabel?.numberOfLines = 2
        return cell
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self] (_) in
            
            networkService.fetchTracks(searchText: searchText) { [weak self] (searchResults) in
                self?.arrayTrack = searchResults?.results ?? []
                self?.tableView.reloadData()
            }
        })
        
    }
}



