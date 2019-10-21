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
    
    enum Rubik {
        
        static func regular(ofSize size: CGFloat) -> UIFont {
            return Resources.Fonts.font(named: "Rubik-Regular", size: size)
        }
        
        static func medium(ofSize size: CGFloat) -> UIFont {
            return Resources.Fonts.font(named: "Rubik-Medium", size: size)
        }
    }
    
    enum Gilroy {
        
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
    
    static let circles = image(named: "circles")
    
    static let easyLevelIconSelected = image(named: "easyLevelSelected")
    
    static let mediumLevelIconSelected = image(named: "mediumLevelSelected")
    
    static let hardLevelIconSelected = image(named: "hardLevelSelected")
    
    static let easyLevelIconUnselected = image(named: "easyLevelUnselected")
    
    static let mediumLevelIconUnselected = image(named: "mediumLevelUnselected")
    
    static let hardLevelIconUnselected = image(named: "hardLevelUnselected")
    
    static let levelsIcon = image(named: "levelsIcon")
    
    static let stopButton = image(named: "stop-circle")
    
    static let arrowDown = image(named: "icn-arrow-down")
    
    static let signInLogo = image(named: "signInLogo")
    
    static let clear = image(named: "clear", template: true)
    
    static let checkSmall = image(named: "checkSmall", template: true)
    
    static let urineDrop = image(named: "urine-drop")
    
    static let dateSmallCircle = image(named: "date-small-circle")
    
    static let urineDropCircle = image(named: "urine-drop-circle")
    
    static let exitIcon = image(named: "icn_exit")
    
    static let lockIcon = image(named: "icn_lock")
    
    static let profileFullIcon = image(named: "profile-full-icon")
    
    static let leftChevron = image(named: "chevron_left")
    
    static let rightChevron = image(named: "chevron_right")

    static let dot = image(named: "dot")
    
    private static func image(named name: String, template: Bool = false) -> UIImage {
        guard let image = UIImage(named: name) else {
            fatalError("There is no '\(name)' image on assets")
        }
        
        return template ? image.withRenderingMode(.alwaysTemplate) : image
    }
}
