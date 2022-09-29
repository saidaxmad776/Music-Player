//
//  SearchViewController.swift
//  Music Player
//
//  Created by Saidaxmad on 28/09/22.
//

import UIKit
import Alamofire


struct TrackModel {
    var trackName: String
    var artistName: String
}

class SearchViewController: UITableViewController {
    
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

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            let url = "https://itunes.apple.com/search"
            let parametrs = ["term":"\(searchText)",
                             "limit":"10"]
            AF.request(url, method: .get, parameters: parametrs, encoding: URLEncoding.default, headers: nil).responseData { (dataResponce) in
                if let error = dataResponce.error {
                    print("ok:\(error.localizedDescription)")
                    return
                }
                
                guard let data = dataResponce.data else { return }
                
                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(SearchResponce.self, from: data)
                    print("objects", objects)
                    self.arrayTrack = objects.results
                    self.tableView.reloadData()
                } catch let jsonError {
                    print("Failed", jsonError)
                }
                
//                let someString = String(data: data, encoding: .utf8)
//                print(someString ?? "")

            }
            
           
        })
        
    }
}
    

