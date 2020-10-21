//
//  MainViewController.swift
//  ZFPlayerTest
//
//  Created by 卢卓桓 on 2019/8/4.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

private let kPlayModeItemH: CGFloat = 50
private let kHeaderView: CGFloat = 60
private let kPlayModeCellID = "kPlayModeCellID"
private let kHeaderViewID = "kHeaderViewID"

var isMainViewDidAppear = false
var isDestViewDidAppear = false

class MainViewController: UIViewController {

    // MARK: - 懒加载属性
    private lazy var collectionView: UICollectionView = { [unowned self] in
        
        ///布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kScreenW, height: kPlayModeItemH)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderView)
        
        ///设置collectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kPlayModeCellID)
        collectionView.register(UINib(nibName: "CollectionModeCell", bundle: nil), forCellWithReuseIdentifier: kPlayModeCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
    }()
    private lazy var playModeModel = [PlayModeSectionModel]()
    
    // MARK: - 自定义属性
    private var childVcs: [UIViewController]?
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //加入子控制器
        //addChildVc(storyBoardName: "Normal")
        setUI()
        loadData()
    }
    
}


// MARK: - 设置UI
extension MainViewController{
    private func setUI(){
        setNavigationBar()
        view.addSubview(collectionView)
    }
    
    private func setNavigationBar(){
        navigationItem.title = "ZFPlayerDemo"
    }
}


// MARK: - 遵守UICollectionView的数据源协议
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return playModeModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playModeModel[section].modeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPlayModeCellID, for: indexPath) as! CollectionModeCell
        
        cell.playMode = playModeModel[indexPath.section].modeArr[indexPath.item]
        cell.navigationController = self.navigationController
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        headerView.playModeSection = playModeModel[indexPath.section]
        
        return headerView
    }
    
    
}

// MARK: - 请求/加载数据
extension MainViewController{
    
    private func loadData(){
        //此处的列表数据可写死（不是网络数据）
        createData(sectionTitle: "播放器样式（PLAYER STYTLE）", itemTitle: "普通样式（Normal Style）", item: ZFNoramlViewController())
    
    }
    
    private func createData(sectionTitle: String, itemTitle: String, item: UIViewController){
        let playModeSection = PlayModeSectionModel()
        playModeSection.title = sectionTitle
        let playModeItem = PlayModeItemModel()
        playModeItem.title = itemTitle
        playModeItem.item = item
        playModeSection.modeArr.append(playModeItem)
        playModeModel.append(playModeSection)
    }
}


