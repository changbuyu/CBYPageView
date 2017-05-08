//
//  ViewController.swift
//  CBYPageViewDemo
//
//  Created by 常布雨 on 17/04/29.
//  Copyright © 2017 CBY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        let titles = ["精选", "电视剧", "电影", "飞雪连天射白鹿","笑书神侠倚碧鸳", "射雕英雄传", "动漫", "VIP会员", "我的"];
//        let titles = ["精选", "电视剧", "电影","VIP会员", "我的"];
        let style = CBYPageStyle()
        style.isScrollable = true
//        style.needScale = true
        style.hasBottomLine = true
//        style.hasMaskView = true
        self.automaticallyAdjustsScrollViewInsets = false
        var childVcs = [UIViewController]()

        for _ in 0..<titles.count{
            let vc = UIViewController()
            vc.automaticallyAdjustsScrollViewInsets = false
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }

        let pageView = CBYPageView(frame: frame, titles: titles, style: style, childVcs: childVcs, parentVc: self)
        view.addSubview(pageView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

