//
//  ZFNoramlViewController.swift
//  ZFPlayerTest
//
//  Created by 卢卓桓 on 2019/8/4.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import ZFPlayer

// MARK: - 定义常量
private let kVideoCover = "https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"

private let kContainerViewW = kScreenW
private let kContainerViewH = kContainerViewW * 9 / 16
private let kContainerViewX: CGFloat = 0
private let kContainerViewY = kStatusBarH + kNavigationBarH
private let kButtonY = kContainerViewY + kContainerViewH + 40
private let kChangeButtonX: CGFloat = 60


class ZFNoramlViewController: UIViewController {

    // MARK: - 自定义属性
    private var currentVedioIndex: Int = -1

    // MARK: - 懒加载属性
    private lazy var player: ZFPlayerController = ZFPlayerController()

    private lazy var containerView: UIImageView = {
        let containerView = UIImageView(frame: CGRect(origin: CGPoint(x: kContainerViewX, y: kContainerViewY), size: CGSize(width: kContainerViewW, height: kContainerViewH)))
        containerView.setImageWithURLString(kVideoCover, placeholder: ZFUtilities.image(with: UIColor(r: 220, g: 220, b: 220), size: CGSize(width: 1, height: 1)))
        return containerView
    }()

    private lazy var  controlView: ZFPlayerControlView = {
        let controlView = ZFPlayerControlView()
        controlView.fastViewAnimated = true        //快进视图是否显示动画
        controlView.autoHiddenTimeInterval = 5     //控制层自动隐藏的时间
        controlView.autoFadeTimeInterval = 0.5     //控制层显示、隐藏动画的时长
        controlView.prepareShowLoading = true      //准备播放的时候时候是否显示loading
        controlView.prepareShowControlView = true  //准备播放时候是否显示控制层
        return controlView
    }()

    private lazy var  playBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame.origin = CGPoint(x: kContainerViewW / 2 - 22, y: kContainerViewH / 2 - 22)
        btn.setImage(UIImage(named: "new_allPlay_44x44_"), for: .normal)
        btn.addTarget(self, action: #selector(playBtnClick), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()

    private lazy var  changeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.frame.origin = CGPoint(x: kChangeButtonX, y: kButtonY)
        btn.setTitle("Change Video", for: .normal)
        btn.addTarget(self, action: #selector(changeVideoBtnClick), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()

    private lazy var  nextBtn: UIButton = { [weak self] in
        let btn = UIButton(type: .system)
        btn.frame.origin = CGPoint(x: kChangeButtonX + self!.changeBtn.bounds.width + 80, y: kButtonY)
        btn.setTitle("Next Video", for: .normal)
        btn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()

    private lazy var assetURLs: [URL]?  = NormalURLConstant
    
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置UI
        setUI()
        
        //设置播放器
        setPlayerProperty()
    }

    
    ///视图将要出现的时候调用
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.isViewControllerDisappear = false
    }
    
    ///视图将要消失的时候
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.isViewControllerDisappear = true
    }
    
    ///修改状态栏风格 全屏：白色  否则：黑色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if (self.player.isFullScreen) {
            return .lightContent;
        }
        return .default;
    }
    
    ///状态栏是否隐藏
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    ///状态栏更改的动画类型
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    ///是否支持自动屏幕旋转  iOS8.1~iOS8.3的值为YES，其他iOS版本的值为NO。
    override var shouldAutorotate: Bool{
        return player.shouldAutorotate
    }
    
    ///支持的接口方向  全屏：横屏   否则：竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if player.isFullScreen{
            return .landscape
        }else{
            return .portrait
        }
    }
    
}

// MARK: - 设置UI
extension ZFNoramlViewController{
    
    private func setUI(){
        view.backgroundColor = UIColor.white
        view.addSubview(containerView)
        containerView.addSubview(playBtn)
        view.addSubview(changeBtn)
        view.addSubview(nextBtn)
    }
}

// MARK: - 设置播放器相关
extension ZFNoramlViewController{
    
    ///设置播放器相关属性
    private func setPlayerProperty(){
        
        let playManager = ZFAVPlayerManager()
        player = ZFPlayerController(playerManager: playManager, containerView: containerView)
        
        ///将设置好的控制层赋给player
        player.controlView = self.controlView
        
        ///设置推到后台是否继续播放
        player.pauseWhenAppResignActive = false
        
        ///即将全屏的时候调用
        player.orientationWillChange = { [weak self]
            (ZFPlayerController, Bool) in
            self!.setNeedsStatusBarAppearanceUpdate() //设置状态栏外观属性（全屏时状态栏外观不同）
        }
        
        ///播放完成时调用
        player.playerDidToEnd = { [weak self]
            (ZFPlayerMediaPlayback) in
            self!.player.currentPlayerManager.replay?()
            self!.player.playTheNext()                    //播放下一个，只适用于设置了`assetURLs`
            guard !(self!.player.isLastAssetURL) else {   //最后一个则停止播放
                self!.player.stop()
                return
            }
            let title = "视频标题\(self!.player.currentPlayIndex + 1)"
            self!.controlView.showTitle(title, coverURLString: kVideoCover, fullScreenMode: .landscape)                              //设置标题、封面、全屏模式
            return
        }
        player.assetURLs = assetURLs
    }
}

// MARK: - 事件监听函数
extension ZFNoramlViewController{
    
    @objc private func playBtnClick(){
        player.playTheIndex(0)
        controlView.showTitle("视频标题\(player.currentPlayIndex + 1)", coverURLString: kVideoCover, fullScreenMode: .automatic)
    }
    
    @objc private func changeVideoBtnClick(){
        var nextIndex = Int(arc4random()) % NormalURLConstant.count
        
        while nextIndex == currentVedioIndex {
            nextIndex = Int(arc4random()) % NormalURLConstant.count
        }
        player.assetURL = NormalURLConstant[nextIndex]
        controlView.showTitle("视频标题\(nextIndex + 1)", coverURLString: kVideoCover, fullScreenMode: .automatic)
        currentVedioIndex = nextIndex
    }
    
    @objc private func nextBtnClick(){
        
        if !(player.isLastAssetURL){
            player.playTheNext()
        }else{
            player.playTheIndex(0)
        }
        controlView.showTitle("视频标题\(player.currentPlayIndex + 1)", coverURLString: kVideoCover, fullScreenMode: .automatic)
    }
}

