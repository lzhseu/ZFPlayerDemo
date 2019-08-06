//
//  PlayModeModel.swift
//  ZFPlayerDemo
//
//  Created by 卢卓桓 on 2019/8/6.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class PlayModeSectionModel {
    
    // MARK: - 模型属性
    var title = ""
    var modeArr = [PlayModeItemModel]()
}

class PlayModeItemModel {
    
    // MARK: - 模型属性
    var title = ""
    var item: UIViewController?
}
