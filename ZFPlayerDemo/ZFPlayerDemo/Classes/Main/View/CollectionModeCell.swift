//
//  CollectionModeCell.swift
//  ZFPlayerDemo
//
//  Created by 卢卓桓 on 2019/8/5.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class CollectionModeCell: UICollectionViewCell {

    // MARK: - 控件属性
    @IBOutlet weak var playModeBtn: UIButton!
    
    // MARK: - 模型属性
    var playMode: PlayModeItemModel? {
        didSet{
            guard let playMode = playMode else {
                return
            }
            playModeBtn.setTitle(playMode.title, for: .normal)
        }
    }
    
    var navigationController: UINavigationController?
    
    // MARK: - 事件监听函数
    @IBAction func playModeBtnClicked(_ sender: Any) {
        guard let navigationController = navigationController else {
            print("导航控制器不存在")
            return
        }
        guard let item = playMode?.item else {
            print("待跳转的子控制器不存在")
            return
        }
        navigationController.pushViewController(item, animated: true)
    }
    
    
    
}
