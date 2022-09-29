//
//  UIViewController + Storyboard.swift
//  Music Player
//
//  Created by Saidaxmad on 29/09/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let soryboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = soryboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error: No initial view controller in \(name) storyboard!")
        }
    }
}
