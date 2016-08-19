//
//  ViewController.swift
//  瀑布流布局
//
//  Created by willphonez on 16/8/18.
//  Copyright © 2016年 willphonez. All rights reserved.
//

import UIKit

// MARK:- 主函数
class ViewController: UIViewController {
    
    // MARK:- 懒加载控件
    private lazy var collectionView = UICollectionView()
    // 所有的商品数据
    private lazy var shops = [ShopItem]()
    
    // cell的标识
    let ID : String = "cell"
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化collectionView
        setupCollectionView()
       
        // 加载数据
        setupRefresh()
    }
}

// MARK:- 加载数据
extension ViewController {
    
    func setupRefresh() {
        // 设置下拉刷新
        collectionView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadData")
        collectionView.header.beginRefreshing()
        
        // 设置上拉加载更多数据
        collectionView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        collectionView.footer.beginRefreshing()
    }
    
    // 加载数据
    @objc private func loadData() {
        
        dispatch_after(2, dispatch_get_main_queue()) { () -> Void in
            
            let path = NSBundle.mainBundle().pathForResource("1.plist", ofType: nil)!
            let shopArray = NSArray(contentsOfFile: path)!
            
            // 清空保存的所有数据
            self.shops.removeAll()
            
            for dict in shopArray {
                let shop = ShopItem.init(dict: dict as! [String : NSObject])
                self.shops.append(shop)
            }
            
            self.collectionView.reloadData()
            self.collectionView.header.endRefreshing()
        }
        
    }
    
    // 加载更多数据
    @objc private func loadMoreData() {
        dispatch_after(2, dispatch_get_main_queue()) { () -> Void in
            
            let path = NSBundle.mainBundle().pathForResource("1.plist", ofType: nil)!
            let shopArray = NSArray(contentsOfFile: path)!
            for dict in shopArray {
                let shop = ShopItem.init(dict: dict as! [String : NSObject])
                self.shops.append(shop)
            }
            
            self.collectionView.reloadData()
            self.collectionView.footer.endRefreshing()
        }
    }
    
}


// MARK:- 初始化collectionView
extension ViewController {
    
    private func setupCollectionView() {
        
        // 创建瀑布流布局
        let waterFlowLayout = ZWFWaterFlowLayout()
        waterFlowLayout.delegate = self
        
        // 创建collectionView
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: waterFlowLayout)
        
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        
        // 注册cell
        collectionView.registerClass(ShopCell.self, forCellWithReuseIdentifier: ID)
        
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }
}

// MARK:- UICollectionViewDataSource
extension ViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 取出cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ID, forIndexPath: indexPath) as! ShopCell
        
        // 设置cell的属性
        cell.shop = shops[indexPath.item];
        
        return cell
    }
    
}

// MARK:- CollectionViewWaterLayoutDelegate
extension ViewController : ZWFWaterFlowLayoutDelegate {
    
    // 返回每个item的高度
    func waterFlowLayout(waterLayout: ZWFWaterFlowLayout, heightForItemAtIndex index: NSInteger, itemWidth : CGFloat) -> CGFloat {
        
        let shop = shops[index]
        
        return shop.h * itemWidth / shop.w
    }
    
    // 返回collectionView的列数
    func columnCountInWaterFlow(waterLayout: ZWFWaterFlowLayout) -> Int {
        return 3
    }
    
    // 返回列间距
    func columnMarginInWaterFlow(waterLayout: ZWFWaterFlowLayout) -> CGFloat {
        return 10
    }
    
    // 返回行间距
    func rowMarginInWaterFlow(waterLayout: ZWFWaterFlowLayout) -> CGFloat {
        return 10
    }
    
    // 返回collectionView的内边距
    func collectViewEdgeInWaterFlow(waterLayout: ZWFWaterFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

