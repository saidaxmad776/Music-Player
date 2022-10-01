//
//  MainTabBarController.swift
//  Music Player
//
//  Created by Saidaxmad on 28/09/22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.backgroundColor = .systemGray6
        
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)

        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        
        viewControllers = [
            generateViewController(rootViewController: searchVC, image: "magnifyingglass", title: "Search"),
            generateViewController(rootViewController: ViewController(), image: "music.note.list", title: "Library")
        ]
        setupTrackDetailView()
    }
    
    private var minimizedTopAchorConstraints: NSLayoutConstraint!
    private var maximizedTopAchorConstraints: NSLayoutConstraint!
    
    private func generateViewController(rootViewController: UIViewController, image: String, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = UIImage(systemName: image)
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
    
    private func setupTrackDetailView() {
        
        let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
        trackDetailView.backgroundColor = .red
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        minimizedTopAchorConstraints = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor,
                                                                            constant: -64)
        maximizedTopAchorConstraints = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor)
        
        maximizedTopAchorConstraints.isActive = true
        trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}


