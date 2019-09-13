//
//  Resources.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/06/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

enum Resources {
    
    enum Fonts {}
    
    enum Images {}
    
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

extension Resources.Images {
    
    static let signedOutBG = image(named: "SignedOutBG")
    
    static let bottomBG = image(named: "bg-bottom")
    
    static let tabCalendar = image(named: "tab-calendar", template: true)
    
    static let tabExercise = image(named: "tab-exercise", template: true)
    
    static let tabProfile = image(named: "tab-profile", template: true)
    
    static let tabVideo = image(named: "tab-video", template: true)
    
    static let playIndicator = image(named: "play-indicator")
    
    static let playButton = image(named: "icn-play")
    
    static let pauseButton = image(named: "icn-pause")
    
    static let replayButton = image(named: "icn-replay")
    
    static let circles = image(named: "circles")
    
    private static func image(named name: String, template: Bool = false) -> UIImage {
        guard let image = UIImage(named: name) else {
            fatalError("There is no '\(name)' image on assets")
        }
        
        return template ? image.withRenderingMode(.alwaysTemplate) : image
    }
}
