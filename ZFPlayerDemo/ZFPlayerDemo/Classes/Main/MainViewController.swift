//
//  MainViewController.swift
//  ZFPlayerTest
//
//  Created by 卢卓桓 on 2019/8/4.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加入子控制器
        addChildVc(storyBoardName: "Normal")
        
        
    }
    
    //通过storyboard拿到控制器，并作为初始控制器的子控制器
    private func addChildVc(storyBoardName: String){
        
        //1.通过storyboard拿到控制器
        let childVc = UIStoryboard(name: storyBoardName, bundle: nil)
            .instantiateInitialViewController()!
        
        //2.将拿到的控制器作为子控制器
        addChild(childVc);
    }
}
