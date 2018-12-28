//
//  ColorExtension.swift
//  Styx
//
//  Created by HwangSeungmin on 12/27/18.
//  Copyright © 2018 Min. All rights reserved.
//

import Foundation
import UIKit


class UIColorForLabel {
    static let colorsArray: Array<UInt> = [UInt(0xC43D3D), UInt(0xF75F4F), UInt(0x499945), UInt(0x4D8B9E), UInt(0x284C24),
                                    UInt(0x494023), UInt(0xC070B0), UInt(0x323254), UInt(0xE9CF00), UInt(0x0858A0), UInt(0x184166)]
    
    static func UIColorFromRGB(colorid: Int) -> UIColor {
        let rgbValue: UInt = UIntFromColorID(id: colorid)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func UIntFromColorID(id: Int) -> UInt! {
        return colorsArray[id]
    }
}
