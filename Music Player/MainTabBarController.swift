//
//  MainTabBarController.swift
//  Music Player
//
//  Created by Saidaxmad on 28/09/22.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: AnyObject {
    func minimizeTrackDetailController()
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    
    private var minimizedTopAchorConstraints: NSLayoutConstraint!
    private var maximizedTopAchorConstraints: NSLayoutConstraint!
    private var bottomAchorContsraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.backgroundColor = .systemGray6
        
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)
        setupTrackDetailView()
        
        searchVC.tabBarDelegate = self
        
        var library = Library()
        library.tabBarDelegate = self
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = UIImage(systemName: "music.note.list")
        hostVC.tabBarItem.title = "Library"
        
        viewControllers = [
            hostVC,
            generateViewController(rootViewController: searchVC, image: "magnifyingglass", title: "Search")
        ]
        
    }
    
    private func generateViewController(rootViewController: UIViewController, image: String, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = UIImage(systemName: image)
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
    
    //        MARK: - Track Detail View Constraints Animate
    private func setupTrackDetailView() {
        
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        minimizedTopAchorConstraints = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor,
                                                                            constant: -64)
        maximizedTopAchorConstraints = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        bottomAchorContsraints = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAchorContsraints.isActive = true
        
        maximizedTopAchorConstraints.isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

//        MARK: - MainTabBarControllerDelegate
extension MainTabBarController: MainTabBarControllerDelegate {
    
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        
        minimizedTopAchorConstraints.isActive = false
        maximizedTopAchorConstraints.isActive = true
        maximizedTopAchorConstraints.constant = 0
        bottomAchorContsraints.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.trackDetailView.miniTrackView.alpha = 0
            self.trackDetailView.maximaizedStackView.alpha = 1
        },
                       completion: nil)
        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel)
    }
    
    func minimizeTrackDetailController() {
        
        maximizedTopAchorConstraints.isActive = false
        bottomAchorContsraints.constant = view.frame.height
        minimizedTopAchorConstraints.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.trackDetailView.miniTrackView.alpha = 1
            self.trackDetailView.maximaizedStackView.alpha = 0
        },
                       completion: nil)
    }
}

