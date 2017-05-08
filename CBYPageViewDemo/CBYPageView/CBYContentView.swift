//
//  CBYContentView.swift
//  CBYPageViewDemo
//
//  Created by 常布雨 on 17/04/30.
//  Copyright © 2017 CBY. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

protocol CBYContentViewDelegate:class {
    func contentView(contentView:CBYContentView, didEndScroll index:Int)
    func contentView(contentView:CBYContentView, soureIndex:Int, targetIndex:Int, progress:CGFloat)
}

class CBYContentView: UIView {
    weak var delegate : CBYContentViewDelegate?
    
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    
    fileprivate var startOffset : CGFloat = 0
    fileprivate var isTrigerDelegate : Bool = true
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:kContentCellID)
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(frame:CGRect, childVcs:[UIViewController], parentVc:UIViewController) {
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
extension CBYContentView{
    fileprivate func setupUI(){
        self.addSubview(collectionView)
    }
}

//MARK:- UICollectionViewDataSource
extension CBYContentView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        cell.contentView.removeAllSubviews()
        let vc = childVcs[indexPath.item];
        vc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(vc.view)
        return cell
    }
}

//MARK:- UICollectionViewDelegate
extension CBYContentView:UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTrigerDelegate = true
        startOffset = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustTitleView(offset: scrollView.contentOffset.x)
    }
    
    fileprivate func adjustTitleView(offset:CGFloat){
        let index = Int(offset/bounds.width)
        delegate?.contentView(contentView: self, didEndScroll: index)
        if offset > startOffset{
            delegate?.contentView(contentView: self, soureIndex: index - 1, targetIndex: index, progress: 1)
        }else{
            delegate?.contentView(contentView: self, soureIndex: index + 1, targetIndex: index, progress: 1)
        }
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.x
        guard currentOffset != startOffset && isTrigerDelegate else {
            return
        }
        
        var sourceIndex : Int
        var targetIndex : Int
        var progress : CGFloat
        if currentOffset > startOffset {//left
            sourceIndex = Int(currentOffset/bounds.width)
            targetIndex = sourceIndex + 1
            
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            if currentOffset - startOffset == bounds.width {
                targetIndex = sourceIndex
            }
            
            progress = (currentOffset - startOffset) / bounds.width
            
        }else{//right
            targetIndex = Int(currentOffset/bounds.width)
            sourceIndex = targetIndex + 1
            progress = (startOffset - currentOffset) / bounds.width
        }
        delegate?.contentView(contentView: self, soureIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
}

//MARK:- CBYTitleViewDelegate
extension CBYContentView:CBYTitleViewDelegate{
    func titleView(titleView: CBYTitleView, index: Int) {
        isTrigerDelegate = false
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}











