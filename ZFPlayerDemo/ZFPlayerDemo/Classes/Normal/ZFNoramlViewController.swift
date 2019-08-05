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
    private var player: ZFPlayerController = ZFPlayerController()
    private var currentVedioIndex: Int = -1

    // MARK: - 懒加载属性
    private lazy var containerView: UIImageView = {
        let containerView = UIImageView(frame: CGRect(origin: CGPoint(x: kContainerViewX, y: kContainerViewY), size: CGSize(width: kContainerViewW, height: kContainerViewH)))
        containerView.setImageWithURLString(kVideoCover, placeholder: ZFUtilities.image(with: UIColor(r: 220, g: 220, b: 220), size: CGSize(width: 1, height: 1)))
        return containerView
    }()

    private lazy var  controlView: ZFPlayerControlView = {
        let controlView = ZFPlayerControlView()
        controlView.fastViewAnimated = true
        controlView.autoHiddenTimeInterval = 5
        controlView.autoFadeTimeInterval = 0.5
        controlView.prepareShowLoading = true
        controlView.prepareShowControlView = true
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.isViewControllerDisappear = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.isViewControllerDisappear = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if (self.player.isFullScreen) {
            return .lightContent;
        }
        return .default;
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    override var shouldAutorotate: Bool{
        return player.shouldAutorotate
    }
    
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
        view.addSubview(containerView)
        containerView.addSubview(playBtn)
        view.addSubview(changeBtn)
        view.addSubview(nextBtn)
    }
}

// MARK: - 设置播放器相关
extension ZFNoramlViewController{
    
    private func setPlayerProperty(){
        
        let playManager = ZFAVPlayerManager()
        player = ZFPlayerController(playerManager: playManager, containerView: containerView)
        
        player.controlView = self.controlView
        
        ///设置推到后台是否继续播放
        player.pauseWhenAppResignActive = false
        
        player.orientationWillChange = { [weak self]
            (ZFPlayerController, Bool) in
            self!.setNeedsStatusBarAppearanceUpdate()
        }
        
        ///播放完成
        player.playerDidToEnd = { [weak self]
            (ZFPlayerMediaPlayback) in
            self!.player.currentPlayerManager.replay?()
            self!.player.playTheNext()
            guard !(self!.player.isLastAssetURL) else {
                self!.player.stop()
                return
            }
            let title = "视频标题\((self!.player.currentPlayIndex ?? -1) + 1)"
            self!.controlView.showTitle(title, coverURLString: kVideoCover, fullScreenMode: .landscape)
            return
        }
        player.assetURLs = assetURLs
    }
}

// MARK: - 事件监听函数
extension ZFNoramlViewController{
    
    @objc private func playBtnClick(){
        player.playTheIndex(0)
        controlView.showTitle("视频标题", coverURLString: kVideoCover, fullScreenMode: .automatic)
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
            controlView.showTitle("视频标题\(player.currentPlayIndex + 1)", coverURLString: kVideoCover, fullScreenMode: .automatic)
        }else{
            print("============--------------------------------==============")
        }
    }
}

