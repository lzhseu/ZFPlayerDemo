//
//  CollectionHeaderView.swift
//  ZFPlayerDemo
//
//  Created by 卢卓桓 on 2019/8/5.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    // MARK: - 控件属性
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - 模型属性
    var playModeSection: PlayModeSectionModel? {
        didSet{
            titleLabel.text = playModeSection?.title
        }
    }
}
