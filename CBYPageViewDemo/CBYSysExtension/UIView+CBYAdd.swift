//
//  UIView+CBYAdd.swift
//  CBYPageViewDemo
//
//  Created by 常布雨 on 17/04/30.
//  Copyright © 2017 CBY. All rights reserved.
//

import UIKit

extension UIView{
    func removeAllSubviews(){
        for view in self.subviews{
            view .removeFromSuperview()
        }
    }
}
