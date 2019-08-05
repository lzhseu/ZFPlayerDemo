//
//  UIColor-Extension.swift
//  ZFPlayerTest
//
//  Created by 卢卓桓 on 2019/8/4.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}
