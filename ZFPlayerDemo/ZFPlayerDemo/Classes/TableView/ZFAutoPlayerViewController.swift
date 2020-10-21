//
//  ZFAutoPlayerViewController.swift
//  ZFPlayerDemo
//
//  Created by 卢卓桓 on 2019/8/6.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class ZFAutoPlayerViewController: UIViewController {

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    

}

// MARK: - 设置UI
extension ZFAutoPlayerViewController{
    private func setUI(){
        view.backgroundColor = UIColor.white
    }
}
