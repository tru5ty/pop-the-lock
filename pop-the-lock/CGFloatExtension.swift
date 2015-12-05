//
//  CGFloatExtension.swift
//  pop-the-lock
//
//  Created by Nathan McGuire on 5/12/2015.
//  Copyright © 2015 Nathan McGuire. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    public static func random() -> CGFloat {
     
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        
        return CGFloat.random() * (max - min) + min
    }
}
