//
//  String.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

extension String {
    
    public var isBlank: Bool {
        
        return trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    public var first: String {
        
        return String(self.prefix(1))
    }
    
    public var last: String {
        
        return String(self.suffix(1))
    }
    
    public var uppercasedFirst: String {
        
        return first.uppercased() + String(self.dropFirst())
    }
    
    public func toNSNumber() -> NSNumber? {
        
        if let number = Int(self) {
            
            return NSNumber(value: number)
            
        } else {
            
            return nil
        }
    }
    
}
