//
//  CBYPageStyle.swift
//  CBYPageViewDemo
//
//  Created by 常布雨 on 17/04/30.
//  Copyright © 2017 CBY. All rights reserved.
//

import UIKit

class CBYPageStyle{
    //titleStyle
    var isScrollable = false
    //title base
    var titleHeight : CGFloat = 44
    var selectedColor : UIColor = UIColor.red
    var normalColor : UIColor = UIColor.darkText
    var titleFont : UIFont = UIFont.systemFont(ofSize: 14.0)
    //title scale
    var needScale : Bool = false
    var hasScaleAnimate : Bool = true
    var maxScale : CGFloat = 1.1
    //bottomline
    var titleMargin : CGFloat = 20
    var hasBottomLine : Bool = true
    var bottomLinwHeight : CGFloat = 2
    var bottomLineColor :  UIColor = UIColor.red
    var hasbottomAnimate : Bool = true
    //maskView
    var hasMaskView : Bool = false;
    var maskViewColor : UIColor = UIColor(white: 0, alpha: 0.3);
    var maskViewHeight : CGFloat = 24;
    var maskViewRadius : CGFloat = 8;
    var maskViewMargin : CGFloat = 5;
    var hasMaskAnimate : Bool = true
}
