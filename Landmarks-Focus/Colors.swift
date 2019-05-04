//
//  Colors.swift
//  Landmarks-Focus
//
//  Created by Alejandro Mendoza on 5/3/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    struct Background {
        static let DeepBlue = UIColor(netHex: 0x0083B0)
        static let LightBlue = UIColor(netHex: 0x00B4DB)
    }
    
    struct Slider {
        static let light = UIColor(netHex: 0xecf0f1)
    }
    
    struct Text {
        static let light = UIColor(netHex: 0xecf0f1)
    }
}


var backgroundColors: [[UIColor]] = [[UIColor.Background.LightBlue, UIColor.red]]
