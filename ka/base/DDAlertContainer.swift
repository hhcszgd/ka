//
//  DDAlertContainer.swift
//  ka
//
//  Created by WY on 2019/7/26.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit
class DDAlertContainer: UIView {
    var isHideWhenWhitespaceClick = true
    var deinitHandle : (()-> ())?
    var backgroundColorAlpha : CGFloat = 0.3
    
    override func didMoveToWindow(){
        super.didMoveToWindow()
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
    ///animate返回值为自定义动画执行时间
    @objc func remove(animate:((DDAlertContainer) -> TimeInterval)? = nil ) {
        if animate != nil {
            let time = animate!(self)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                self.subviews.forEach({ (subview) in
                    subview.removeFromSuperview()
                })
                self.removeFromSuperview()
                self.deinitHandle?()
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (bool ) in
                self.subviews.forEach({ (subview) in
                    subview.removeFromSuperview()
                })
                self.removeFromSuperview()
                self.deinitHandle?()
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchBegainAction(touches, with: event)
        if let firstView = self.subviews.first{
            if let point = touches.first?.location(in: self){
                for subview in self.subviews{
                    if subview.frame.contains(point){
                        return
                    }
                }
                //                if firstView.frame.contains(point){
                //                    return
                //                }
            }
        }
        
        self.corverViewPart()
        if isHideWhenWhitespaceClick {self.remove()}
    }
    /// to be override
    func corverViewPart() {
        mylog("corver view part touch")
    }
    /// to be override
    func touchBegainAction(_ touches: Set<UITouch>, with event: UIEvent?) {
        mylog("touch begain")
    }
    deinit {
        self.deinitHandle?()
        print("cover destroyed")
    }
}


extension  UIView {
    @discardableResult
    func alert<T : DDAlertContainer>(_ cover:T , animate:((T) -> ())? = nil )  -> T{
        var existCount = 0
        for subview in self.subviews{
            if subview.isKind(of: T.self) { existCount += 1 }
        }
        if existCount <= 1 {self.addSubview(cover)}
        
        cover.frame = self.bounds
        
        if animate != nil {
            animate!(cover)
        }else{
            cover.alpha = 0
            let tempColor = cover.backgroundColor ?? UIColor.black
            cover.backgroundColor = tempColor.withAlphaComponent(cover.backgroundColorAlpha)
            UIView.animate(withDuration: 0.3) {
                cover.alpha = 1
            }
        }
        return cover
    }
    func removeAllMaskView<T : DDAlertContainer>(maskClass:T.Type) {
        for subview in self.subviews{
            if subview.isKind(of: T.self) {
                subview.removeFromSuperview()
            }
        }
    }
}
