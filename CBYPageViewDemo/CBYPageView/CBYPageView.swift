//
//  CBYPageView.swift
//  CBYPageViewDemo
//
//  Created by 常布雨 on 17/04/30.
//  Copyright © 2017 CBY. All rights reserved.
//

import UIKit

class CBYPageView: UIView {
//MARK:- properties
    fileprivate var titles : [String]
    fileprivate var style : CBYPageStyle
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    
    init(frame: CGRect, titles:[String],style:CBYPageStyle,childVcs:[UIViewController], parentVc:UIViewController) {
        self.titles = titles
        self.style = style
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- UI
extension CBYPageView{
    fileprivate func setupUI(){
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        let titleView = CBYTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.hexColor(hexString: "0xdedede")
        self.addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleView.frame.maxY, width: bounds.width, height: frame.height - titleView.frame.maxY)
        let contentView = CBYContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        self.addSubview(contentView)
        
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}


