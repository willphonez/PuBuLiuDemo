//
//  ShopCell.swift
//  瀑布流布局
//
//  Created by willphonez on 16/8/18.
//  Copyright © 2016年 willphonez. All rights reserved.
//

import UIKit

class ShopCell: UICollectionViewCell {
    
    // MARK:- 懒加载控件
    private lazy var imageView : UIImageView = UIImageView()
    private lazy var label : UILabel = UILabel()
    
    // MARK:- 商品模型
    var shop : ShopItem = ShopItem() {
        didSet {
            guard let url = NSURL(string: shop.img) else {
                return
            }
            imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "arrow"))
            label.text = shop.price
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // MARK:- 初始化UI界面
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShopCell {
    
    func setupUI() {
        contentView.addSubview(imageView)
        
        label.backgroundColor = UIColor(white: 0.8, alpha: 0.6)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
        
        let w : CGFloat = contentView.bounds.width;
        let h : CGFloat = 30;
        let x : CGFloat = 0;
        let y : CGFloat = contentView.bounds.height - h;
        label.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
}

