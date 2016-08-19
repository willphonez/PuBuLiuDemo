//
//  ShopItem.swift
//  瀑布流布局
//
//  Created by willphonez on 16/8/18.
//  Copyright © 2016年 willphonez. All rights reserved.
//

import UIKit

class ShopItem: NSObject {
    // 定义商品属性
    var w : CGFloat = 0
    var h : CGFloat = 0
    var img : String = ""
    var price : String = ""
    
    override init() {
        super.init()
    }
    
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}
