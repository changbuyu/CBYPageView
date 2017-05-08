//
//  CBYTitleView.swift
//  CBYPageViewDemo
//
//  Created by 常布雨 on 17/04/30.
//  Copyright © 2017 CBY. All rights reserved.
//

import UIKit

protocol CBYTitleViewDelegate:class {
    func titleView(titleView:CBYTitleView, index:Int);
}

class CBYTitleView: UIView {
    weak var delegate : CBYTitleViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var style : CBYPageStyle
    fileprivate var isDelegate : Bool = false //判断是由点击还是代理引起的变化
    
    fileprivate var currentIndex : Int = 0
    fileprivate lazy var selectedRGBA : (CGFloat,CGFloat,CGFloat,CGFloat) = self.style.selectedColor.getFloatOfRGBA()
    fileprivate lazy var normalRGBA : (CGFloat,CGFloat,CGFloat,CGFloat) = self.style.normalColor.getFloatOfRGBA()
    fileprivate lazy var deletaRGBA : (CGFloat,CGFloat,CGFloat,CGFloat) = {
        let r = self.normalRGBA.0 - self.selectedRGBA.0
        let g = self.normalRGBA.1 - self.selectedRGBA.1
        let b = self.normalRGBA.1 - self.selectedRGBA.1
        return (r,g,b,1.0)
    }()
    
    fileprivate lazy var titleMask : UIView = {
        let view = UIView()
        view.backgroundColor = self.style.maskViewColor
        view.layer.cornerRadius = self.style.maskViewRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var bottleLine : UIView = {
        let view = UIView()
        view.backgroundColor = self.style.bottomLineColor
        return view
    }()
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    fileprivate var labels = [UILabel]()
    
    init(frame:CGRect, titles:[String], style:CBYPageStyle) {
        self.titles = titles
        self.style = style
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- UI
extension CBYTitleView{
    fileprivate func setupUI(){
        self.addSubview(scrollView)
        setupLabels(titles: titles)
        setupLabelsFrame()
        if style.hasBottomLine{
            setupBottomLine()
        }
        if style.hasMaskView{
            setupBackgroundView()
        }
    }
    
    private func setupLabels(titles:[String]){
        for (i, title) in titles.enumerated(){
            let label = UILabel()
            label.text = title;
            label.textColor = i == 0 ? style.selectedColor : style.normalColor
            label.textAlignment = .center
            label.font = style.titleFont
            label.tag = i + 1000
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelClicked(tap:)))
            label.addGestureRecognizer(tap)
            labels.append(label)
            scrollView.addSubview(label);
        }
    }
    
    private func setupLabelsFrame(){
        var labelX : CGFloat = 0
        let labelY : CGFloat = 0
        let labelH : CGFloat = style.titleHeight
        var labelW : CGFloat = bounds.width/CGFloat(titles.count)
        for (i,label) in labels.enumerated(){
            if style.isScrollable {
                let maxSize = CGSize(width: CGFloat(MAXFLOAT), height: 0)
                labelW = (label.text! as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : style.titleFont], context: nil).width
                labelX = i == 0 ? style.titleMargin * 0.5 : (labels[i-1].frame.maxX + style.titleMargin)
            }else{
                labelX = CGFloat(i) * bounds.width / CGFloat(titles.count)
            }
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        if style.isScrollable {
            scrollView.contentSize = CGSize(width: labels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
        
        if style.needScale {
            labels.first?.transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
    }
    
    private func setupBottomLine(){
        scrollView.addSubview(bottleLine)
        bottleLine.frame.size.width = labels.first!.bounds.width
        bottleLine.frame.size.height = style.bottomLinwHeight
        bottleLine.frame.origin.x = labels.first!.frame.origin.x
        bottleLine.frame.origin.y = style.titleHeight - style.bottomLinwHeight
    }
    
    private func setupBackgroundView(){
        scrollView.insertSubview(titleMask, at: 0);
        let label = labels.first!
        titleMask.frame = self.calculteMaskViewFrame(label: label)
    }

}

//MARK:- action
extension CBYTitleView{
    @objc fileprivate func labelClicked(tap:UITapGestureRecognizer){
        guard let targetLabel = tap.view as? UILabel else{
            return
        }
        
        let index = targetLabel.tag - 1000
        
        guard index != currentIndex else {
            return
        }
        
        isDelegate = false
        
        //change selected label
        let preLabel = labels[currentIndex]
        preLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectedColor
        currentIndex = index
        
        //set contentSize
        adjustTitleView()

        if style.needScale {
            if style.hasScaleAnimate {
                UIView.animate(withDuration: 0.25, animations: {
                    preLabel.transform = CGAffineTransform.identity
                    targetLabel.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
                })
            }else{
                preLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            }
        }
        
        //set contentView
        delegate?.titleView(titleView: self, index: currentIndex)
    }
    
    fileprivate func adjustTitleView(){
        let targetLabel = labels[currentIndex]

        let maxoffset : CGFloat = labels.last!.frame.maxX + style.titleMargin - bounds.width
        var offset : CGFloat = targetLabel.center.x - scrollView.bounds.width * 0.5
        if offset < 0 {
            offset = 0
        }else if offset > maxoffset{
            offset = maxoffset
        }
        
        if style.hasBottomLine {
            if style.hasbottomAnimate {
                UIView.animate(withDuration: 0.25, animations: { 
                    self.adjustbottomline(targetLabel: targetLabel)
                })
            }else{
                adjustbottomline(targetLabel: targetLabel)
            }
        }
        
        if style.hasMaskView {
            if style.hasMaskAnimate{
                UIView.animate(withDuration: 0.25, animations: { 
                    self.adjustMaskView(targetLabel: targetLabel)
                })
            }else{
                adjustMaskView(targetLabel: targetLabel)
            }
            
        }
        
        if style.isScrollable {
            scrollView.setContentOffset(CGPoint(x:offset, y:0), animated: true)
        }
        
    }
    
    private func adjustbottomline(targetLabel:UILabel){
        var scale : CGFloat = 0
        if style.needScale {
            scale = style.maxScale
        }else{
            scale = 1.0
        }
        if isDelegate {
            scale = 1.0
        }
        bottleLine.frame.origin.x = targetLabel.frame.origin.x - targetLabel.frame.width * (scale - 1.0) * 0.5
        bottleLine.frame.size.width = targetLabel.frame.width * scale
    }
    
    private func adjustMaskView(targetLabel:UILabel){
        titleMask.frame = self.calculteMaskViewFrame(label: targetLabel)
    }
}

//MARK:- calculate
extension CBYTitleView{
    fileprivate func calculteMaskViewFrame(label:UILabel) -> CGRect{
        let maskH = style.maskViewHeight
        let maskW = style.isScrollable ? (label.frame.width + style.maskViewMargin * 2) : (label.frame.width - style.maskViewMargin * 2)
        let maskX = style.isScrollable ? (label.frame.origin.x - style.maskViewMargin) : (label.frame.origin.x + style.maskViewMargin)
        let maskY = (label.frame.height - style.maskViewHeight) * 0.5
        let frame = CGRect(x: maskX, y: maskY, width: maskW, height: maskH)
        return frame
    }
}



//MARK:- CBYContentViewDelegate
extension CBYTitleView:CBYContentViewDelegate{
    func contentView(contentView: CBYContentView, didEndScroll index:Int) {
        currentIndex = index
        isDelegate = true
        if style.isScrollable {
            adjustTitleView()
        }
    }
    
    func contentView(contentView:CBYContentView, soureIndex:Int, targetIndex:Int, progress:CGFloat){
        let sourceLabel = labels[soureIndex]
        let targetLabel = labels[targetIndex]
        
        for label in labels{
            label.textColor = style.normalColor
        }
        
        var r = selectedRGBA.0 + deletaRGBA.0 * progress
        var g = selectedRGBA.1 + deletaRGBA.1 * progress
        var b = selectedRGBA.2 + deletaRGBA.2 * progress
        
        sourceLabel.textColor = UIColor(r: r, g: g, b: b)
        
        r = normalRGBA.0 - deletaRGBA.0 * progress
        g = normalRGBA.1 - deletaRGBA.1 * progress
        b = normalRGBA.2 - deletaRGBA.2 * progress
        
        targetLabel.textColor = UIColor(r: r, g: g, b: b)
        
        if style.hasBottomLine && style.hasbottomAnimate {
            let deletaW = targetLabel.frame.width - sourceLabel.frame.width
            let deletaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            bottleLine.frame.origin.x = sourceLabel.frame.origin.x + deletaX * progress
            bottleLine.frame.size.width = sourceLabel.frame.width + deletaW * progress
        }
        
        if style.needScale && style.hasScaleAnimate{
            let deleta = style.maxScale - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.maxScale - deleta * progress, y: style.maxScale - deleta * progress)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + deleta * progress, y: 1.0 + deleta * progress)
        }
        
        let oldFrame = calculteMaskViewFrame(label: sourceLabel)
        var newFrame = calculteMaskViewFrame(label: targetLabel)
        let deltaX = (newFrame.origin.x - oldFrame.origin.x) * progress
        let deltaW = (newFrame.width - oldFrame.width) * progress
        if style.hasMaskView {
            newFrame.origin.x = oldFrame.origin.x + deltaX
            newFrame.size.width = oldFrame.width + deltaW
            titleMask.frame = newFrame
        }
    }
}








