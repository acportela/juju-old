//
//  UINavigationController.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func configureOpaqueStyle() {
        
        self.view.backgroundColor = Styling.Colors.softPink
        self.navigationBar.shadowImage = nil
        self.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationBar.isTranslucent = false
        
        self.navigationBar.barStyle = .black
        self.navigationBar.barTintColor = Styling.Colors.softPink
        self.navigationBar.tintColor = Styling.Colors.white
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Resources.Fonts.Gilroy.extraBold(ofSize: Styling.FontSize.twenty),
            NSAttributedString.Key.foregroundColor: Styling.Colors.white
        ]
        
        self.navigationBar.layer.cornerRadius = 15
        self.navigationBar.clipsToBounds = true
        self.navigationBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

}
