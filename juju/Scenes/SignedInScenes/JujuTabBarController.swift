//
//  JujuTabBarController.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

class JujuTabBarController: UITabBarController {
    
    init(viewControllers: [UIViewController], initialIndex: Int) {
        
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        self.selectedIndex = initialIndex
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        self.view.backgroundColor = Styling.Colors.white
        self.tabBar.backgroundColor = Styling.Colors.white
        self.tabBar.tintColor = Styling.Colors.rosyPink
        self.tabBar.unselectedItemTintColor = Styling.Colors.rosyPink.withAlphaComponent(0.32)
        self.delegate = self
        
        self.navigationItem.title = self.selectedViewController?.title
    }
}

extension JujuTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    
        self.navigationItem.title = viewController.title
    }
}
