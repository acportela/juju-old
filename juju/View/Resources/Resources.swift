//
//  Resources.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/06/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

enum Resources {
    
    enum Colors {}
    
    enum Fonts {}
    
    enum Images {}
    
}

extension Resources.Colors {
    
    static let softPink = UIColor(red: 255, green: 161, blue: 172)

    static let rosyPink = UIColor(red: 242, green: 118, blue: 133)
    
    static let white = UIColor(red: 241, green: 241, blue: 241)
    
}

extension Resources.Fonts {
    
    enum Montserrat {
        
        static func regular(ofSize size: CGFloat) -> UIFont {
            return Resources.Fonts.font(named: "Montserrat-Regular", size: size)
        }
        
        static func medium(ofSize size: CGFloat) -> UIFont {
            return Resources.Fonts.font(named: "Montserrat-Medium", size: size)
        }
        
        static func bold(ofSize size: CGFloat) -> UIFont {
            return Resources.Fonts.font(named: "Montserrat-Bold", size: size)
        }
        
        static func extraBold(ofSize size: CGFloat) -> UIFont {
            return Resources.Fonts.font(named: "Montserrat-ExtraBold", size: size)
        }
        
    }
    
    enum Gilroy {
        
        static func regular(ofSize size: CGFloat) -> UIFont {
            return Resources.Fonts.font(named: "Gilroy-Regular", size: size)
        }
        
        static func medium(ofSize size: CGFloat) -> UIFont {
            return Resources.Fonts.font(named: "Gilroy-Medium", size: size)
        }
        
        static func bold(ofSize size: CGFloat) -> UIFont {
            return Resources.Fonts.font(named: "Gilroy-Bold", size: size)
        }
        
        static func extraBold(ofSize size: CGFloat) -> UIFont {
            return Resources.Fonts.font(named: "Gilroy-ExtraBold", size: size)
        }
        
    }
    
    private static func font(named: String, size: CGFloat) -> UIFont {
        
        guard let font = UIFont(name: named, size: size) else {
            fatalError("The font \(named) was not found")
        }
        
        return font
    }
}
