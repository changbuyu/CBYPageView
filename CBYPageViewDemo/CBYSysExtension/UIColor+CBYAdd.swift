//
//  UIColor+CBYAdd.swift
//  CBYPageViewDemo
//
//  Created by 常布雨 on 17/04/30.
//  Copyright © 2017 CBY. All rights reserved.
//

import UIKit
//MARK:- initialize & class method
extension UIColor {
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    class func randomColor() -> UIColor{
       return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    class func hexColor(hexString:String) -> UIColor{
        guard hexString.characters.count > 6 else {
            fatalError("check your hexString")
        }
        let str = hexString.uppercased() as String
        //0x 0X 0##
        var rhex = ""
        var ghex = ""
        var bhex = ""
        if str.hasPrefix("0X") || str.hasPrefix("##") {
            var range = NSMakeRange(2, 2);
            rhex = (str as NSString).substring(with: range)
            range.location = 4
            ghex = (str as NSString).substring(with: range)
            range.location = 6
            bhex = (str as NSString).substring(with: range)
        }else if(str.hasPrefix("#")){
            var range = NSMakeRange(1, 2);
            rhex = (str as NSString).substring(with: range)
            range.location = 3
            ghex = (str as NSString).substring(with: range)
            range.location = 5
            bhex = (str as NSString).substring(with: range)
        }else{
            fatalError("check your hexString")
        }
        
        var r : UInt32 = 0, g : UInt32 = 0, b : UInt32 = 0;
        
        Scanner(string: rhex).scanHexInt32(&r)
        Scanner(string: ghex).scanHexInt32(&g)
        Scanner(string: bhex).scanHexInt32(&b)
        
        return UIColor(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b));
 
    }
}
//MARK:- instance method
extension UIColor{
    func getFloatOfRGBA() -> (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
    
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r*255, g*255, b*255, a)
    }
}














