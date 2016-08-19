//
//  ZWFWaterFlowLayout.swift
//  瀑布流布局
//
//  Created by willphonez on 16/8/18.
//  Copyright © 2016年 willphonez. All rights reserved.
//

import UIKit

// MARK:- 定义一份协议用来让外界传递瀑布流所需的相应的数据
@objc protocol ZWFWaterFlowLayoutDelegate {
    
    // 每个item的高度
    func waterFlowLayout(waterLayout: ZWFWaterFlowLayout, heightForItemAtIndex index: NSInteger, itemWidth : CGFloat) -> CGFloat
    // collectionView的列数
    optional func columnCountInWaterFlow(waterLayout : ZWFWaterFlowLayout) -> Int
    // item间的列间距
    optional func columnMarginInWaterFlow(waterLayout : ZWFWaterFlowLayout) -> CGFloat
    // item间的行间距
    optional func rowMarginInWaterFlow(waterLayout : ZWFWaterFlowLayout) -> CGFloat
    // collectionView的内边距
    optional func collectViewEdgeInWaterFlow(waterLayout : ZWFWaterFlowLayout) -> UIEdgeInsets
}

class ZWFWaterFlowLayout: UICollectionViewLayout {
    
    // MARK:- 保存所有cell的布局
    private lazy var itemAttributeArray = [UICollectionViewLayoutAttributes]()
    
    // MARK:- 保存当前所有列的总高度
    private lazy var columnHeightArray = [CGFloat]()
    
    // MARK:- 代理
    var delegate : ZWFWaterFlowLayoutDelegate?
    
}

// MARK:- 一些基本属性(由外界提供)
extension ZWFWaterFlowLayout {
    // MARK:- 列间距
    func columnMargin() -> CGFloat {
        // 校验有没有代理
        if delegate == nil {  // 默认列间距为10
            return 10
        }
        // 校验代理有没有实现方法
        guard let margin = delegate!.columnMarginInWaterFlow?(self) else { // 默认列间距为10
            return 10
        }
        return margin
    }
    // MARK:- 列数
    func columnCount() -> Int {
        // 校验有没有代理
        if delegate == nil { // 默认列数为3
            return 3
        }
        // 校验代理有没有实现方法
        guard let count = delegate!.columnCountInWaterFlow?(self) else { // 默认列数为3
            return 3
        }
        return count
    }
    // MARK:- 行间距
    func rowMargin() -> CGFloat {
        // 校验有没有代理
        if delegate == nil {  // 默认行间距为10
            return 10
        }
        // 校验代理有没有实现方法
        guard let margin = delegate!.rowMarginInWaterFlow?(self) else {  // 默认行间距为10
            return 10
        }
        return margin
    }
    // MARK:- 四边内间距
    func collectViewEdgeInsets() -> UIEdgeInsets {
        // 校验有没有代理
        if delegate == nil {  // 默认四周内边距为10
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        // 校验代理有没有实现方法
        guard let edgeInsets = delegate!.collectViewEdgeInWaterFlow?(self) else {  // 默认四周内边距为10
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        return edgeInsets
    }
}

// MARK:- 瀑布流核心实现代码
extension ZWFWaterFlowLayout {
    
    // 初始化布局方法
    override func prepareLayout() {
        super.prepareLayout()
        // 清空之前所有的列数的高度数据,并初始化
        columnHeightArray.removeAll()
        for _ in 0..<columnCount() {
            columnHeightArray.append(0)
        }
      
        // 清空之前所有cell的布局属性
        itemAttributeArray.removeAll()
        
        // collectionView中的cell的个数
        let count = collectionView?.numberOfItemsInSection(0) ?? 0
        
        for i in 0..<count {
            
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            
            // 根据indexPath设置对应的layoutAttributes
            let layoutAttribute = layoutAttributesForItemAtIndexPath(indexPath)!
            
            itemAttributeArray.append(layoutAttribute)
        }
        
    }
    
    // 确定指定范围内(rect)的item的布局属性,由于指定范围内的item可能有多个,所以返回一个数组
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributeArray
    }
    
    // 确定每个item的布局属性(核心代码),在这个方法里确定每个item的frame
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        // 创建单个cell的布局属性
        let layoutAttribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        // 设置布局属性
        
        // collectionView的宽度
        let collectionViewW = collectionView!.frame.size.width
        // 一行中所有item的总宽度
        let itemWs = collectionViewW - collectViewEdgeInsets().left - collectViewEdgeInsets().right - CGFloat(columnCount() - 1) * columnMargin()
        
        // 找出最矮的一列
        // 假设第一列最矮
        var minHeight : CGFloat = columnHeightArray[0]
        var desRow : Int = 0
        for i in 1..<columnHeightArray.count {
            let height = columnHeightArray[i]
            
            if height < minHeight {
                minHeight = height
                desRow = i
            }
        }
        
        // 确定item的frame
        let w : CGFloat = itemWs /  CGFloat(columnCount())
        let x : CGFloat = collectViewEdgeInsets().left + (columnMargin() + w) * CGFloat(desRow)
        let y : CGFloat = columnHeightArray[desRow] + rowMargin()
        let h : CGFloat = (delegate?.waterFlowLayout(self, heightForItemAtIndex: indexPath.item, itemWidth: w))!
        layoutAttribute.frame = CGRect(x: x, y: y, width: w, height: h)
        
        // 更新列高度数据
        columnHeightArray[desRow] = CGRectGetMaxY(layoutAttribute.frame)
        
        return layoutAttribute
    }
    
    // 确定contentSize
    override func collectionViewContentSize() -> CGSize {
        // 找出最高的一列
        // 假设第一列最高
        var maxHeight : CGFloat = columnHeightArray[0]
        var desRow : Int = 0
        for i in 1..<columnHeightArray.count {
            let height = columnHeightArray[i]
            
            if height > maxHeight {
                maxHeight = height
                desRow = i
            }
        }
        
        return CGSize(width: 0, height: columnHeightArray[desRow] + rowMargin())
    }
}