//
//  Styling.swift
//  juju
//
//  Created by Antonio Portela on 25/08/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

enum Styling {
    
    enum Colors {}
    
    enum Spacing {}
    
    enum FontSize {}
}

extension Styling.Colors {
    
    static let softPink = UIColor(red: 255, green: 161, blue: 172)
    
    static let rosyPink = UIColor(red: 242, green: 118, blue: 133)
    
    static let veryLightPink = UIColor(red: 241, green: 241, blue: 241)
    
    static let white = UIColor(red: 255, green: 255, blue: 255)
    
    static let duskyPink = UIColor(red: 208, green: 120, blue: 132)
    
    static let duskyRose = UIColor(red: 189, green: 97, blue: 109)
    
    static let softPinkTwo = UIColor(red: 255, green: 175, blue: 186)
    
    static let lightPeriwinkle = UIColor(red: 226, green: 228, blue: 233)
    
    static let charcoalGrey = UIColor(red: 59, green: 65, blue: 75)
}

extension Styling.Spacing {
    
    static let four: CGFloat =  4
    
    static let eight: CGFloat =  8
    
    static let twelve: CGFloat =  12
    
    static let fourteen: CGFloat =  14
    
    static let sixteen: CGFloat =  16
    
    static let eighteen: CGFloat =  18
    
    static let twentyfour: CGFloat =  24
    
    static let twentyeight: CGFloat =  28
    
    static let thirtytwo: CGFloat = 32
    
    static let fourtyeight: CGFloat = 48
}

extension Styling.FontSize {
    
    static let twelve: CGFloat =  12
    
    static let sixteen: CGFloat =  16
    
    static let fourteen: CGFloat =  14
    
    static let eighteen: CGFloat =  18
    
    static let twenty: CGFloat =  20
    
    static let thirtysix: CGFloat =  36
    
    static let sixty: CGFloat =  60
}
