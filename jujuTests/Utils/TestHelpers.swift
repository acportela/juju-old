//
//  TestHelpers.swift
//  jujuTests
//
//  Created by Antonio Rodrigues on 01/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

struct TestHelpers {
    
    static let iphone8width = 375
    static let iphone8Height = 667
   
    static let iphoneXwidth = 375
    static let iphoneXHeight = 812
    
    static let iphoneXSMaxWidth = 414
    static let iphoneXSMaxHeight = 896
    
    static var iphone8Frame: CGRect {
        return CGRect(x: 0, y: 0, width: TestHelpers.iphone8width, height: TestHelpers.iphone8Height)
    }
    
    static var iphoneXFrame: CGRect {
        return CGRect(x: 0, y: 0, width: TestHelpers.iphoneXwidth, height: TestHelpers.iphoneXHeight)
    }
    
    static var iphoneXSMaxFrame: CGRect {
        return CGRect(x: 0, y: 0, width: TestHelpers.iphoneXSMaxWidth, height: TestHelpers.iphoneXSMaxHeight)
    }
    
}
