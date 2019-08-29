//
//  AddFireAssistent.swift
//  KeyFrameAnimate
//
//  Created by WY on 2019/8/28.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit
struct  FirePathPoint {
    var startPoint:CGPoint
    var curve1Point:CGPoint
    var curve2Point:CGPoint
    var endPoint:CGPoint
    init(_ startPointX : CGFloat , _ startPointY : CGFloat   , _ curve1PointX:CGFloat,_ curve1PointY:CGFloat , _ curve2PointX:CGFloat, _ curve2PointY:CGFloat , _ endPointX : CGFloat,_ endPointY : CGFloat) {
        self.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.curve1Point = CGPoint(x: curve1PointX, y: curve1PointY)
        self.curve2Point = CGPoint(x: curve2PointX, y: curve2PointY)
        self.endPoint  = CGPoint(x: endPointX, y: endPointY)
    }
    
    mutating func add(vector: CGVector) ->  FirePathPoint{
        var copy = self
        copy.startPoint.x += vector.dx
        copy.startPoint.y += vector.dy
        copy.curve1Point.x += vector.dx
        copy.curve1Point.y += vector.dy
        copy.curve2Point.x += vector.dx
        copy.curve2Point.y += vector.dy
        copy.endPoint.x += vector.dx
        copy.endPoint.y += vector.dy
        
        return copy
    }
    mutating func multiply(by value: CGFloat)  ->  FirePathPoint{
        var copy = self
        copy.startPoint.x *= value
        copy.startPoint.y *= value
        
        copy.curve1Point.x *= value
        copy.curve1Point.y *= value
        
        copy.curve2Point.x *= value
        copy.curve2Point.y *= value
        
        copy.endPoint.x *= value
        copy.endPoint.y *= value
        
        return copy
    }
    
}
class AddFireAssistent  {
    static var share  = AddFireAssistent()
    
    private lazy var fireFlow: [FirePathPoint] = {
        return [
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74,  0.0, -0.85),//shang
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74, 0.10, -0.80),
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74, 0.15, -0.75),
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74, 0.20, -0.70),//You
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74, 0.15, -0.60),
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74, 0.10, -0.50),
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74, 0.00, -0.50),//xia
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74, -0.15, -0.60),
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74, -0.10, -0.50),
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74, -0.20, -0.70),//zuo
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74, -0.10, -0.80),
            FirePathPoint(0.00, 0.00, 0.0, -1,0.0, -0.74, -0.15, -0.75),
            
        ]
    }()
    
    private lazy var topRight: [FirePathPoint] = {
        return [
            FirePathPoint(0.00, 0.00, 0.31, -0.46, 0.74, -0.29, 0.99, 0.12),
            FirePathPoint(0.00, 0.00, 0.31, -0.46, 0.62, -0.49, 0.88, -0.19),
            FirePathPoint(0.00, 0.00, 0.10, -0.54, 0.44, -0.53, 0.66, -0.30),
            FirePathPoint(0.00, 0.00, 0.19, -0.46, 0.41, -0.53, 0.65, -0.45),
        ]
    }()

    private lazy var bottomRight: [FirePathPoint] = {
        return [
            FirePathPoint(0.00, 0.00, 0.42, -0.01, 0.68, 0.11, 0.87, 0.44),
            FirePathPoint(0.00, 0.00, 0.35, 0.00, 0.55, 0.12, 0.62, 0.45),
            FirePathPoint(0.00, 0.00, 0.21, 0.05, 0.31, 0.19, 0.32, 0.45),
            FirePathPoint(0.00, 0.00, 0.18, 0.00, 0.31, 0.11, 0.35, 0.25),
        ]
    }()
    
    public var delay: TimeInterval = 0.16
    private var timer: Timer?
    public static var sparkColorSet: [UIColor] = {
        return [
            UIColor(red:0.89, green:0.58, blue:0.70, alpha:1.00),
            UIColor(red:0.96, green:0.87, blue:0.62, alpha:1.00),
            UIColor(red:0.67, green:0.82, blue:0.94, alpha:1.00),
            UIColor(red:0.54, green:0.56, blue:0.94, alpha:1.00),
        ]
    }()
    var view : UIView?
    var touches: Set<UITouch>?
//    var point : CGPoint = CGPoint.zero
    var firePoint : FirePathPoint{
        var p = CGPoint.zero
        if view != nil  {
            if let superview = view!.superview{
                p = superview.convert(view!.center, to: UIApplication.shared.keyWindow!)
            }else{
                fatalError("this view has no superView")
            }
        }else if touches != nil {
            let touch : UITouch = touches!.first!;
            p = touch.location(in: UIApplication.shared.keyWindow!)
            
        }else{
            self.cancel()
        }
//        if p == CGPoint.zero {p = CGPoint(x: 200, y: 200)}
//        let b = a.multiply(by: 2)
        var a = topRight[Int(arc4random_uniform(3))].multiply(by: 55)
        let b = a.add(vector: CGVector(dx: p.x, dy: p.y))
        return b
    }
    
    
    public func cancel() {
        self.timer?.invalidate()
        self.timer = nil
//        self.view = nil
//        self.touches = nil
    }
    public  func startByTouches(_ touches: Set<UITouch>){
        self.touches = touches
        scheduleTimer()
    }
    public   func startByView(_ view: UIView){
        self.view = view
        if let superview = view.superview{
    
        }else{
            fatalError("this view has no superView")
        }
        print("this is startByView method ")
        
        
    }
    private func scheduleTimer() {
//        self.cancel()
//        self.timer = Timer(timeInterval: self.delay, target: self , selector: #selector(timerDidFire), userInfo: nil , repeats: true )
        self.timer = Timer(timeInterval: self.delay, target: self , selector: #selector(timerDidFire), userInfo: nil , repeats: false  )
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
    }
    
      @objc private func timerDidFire() {

            let timeInterval : CFTimeInterval = 0.6
            //https://www.desmos.com/calculator/epunzldltu
  
            
            let paths : [(curve1Point: CGPoint , curve2Point : CGPoint , endPoint : CGPoint)] = [
                (curve1Point: CGPoint(x: 80, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 178, y: 400)),
                (curve1Point: CGPoint(x: 91, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 278, y: 400)),
                (curve1Point: CGPoint(x: 99, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 200, y: 700)),
                (curve1Point: CGPoint(x: 110, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 150, y: 400)),
                (curve1Point: CGPoint(x: 75, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 133, y: 400)),
                (curve1Point: CGPoint(x: 87, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 300, y: 400)),
            ]
            let path = UIBezierPath()
            let fireView  = VVVV(frame: CGRect(x: 50, y: 100, width: 15, height: 15))
        fireView.layer.cornerRadius = 7.5
            UIApplication.shared.keyWindow?.addSubview(fireView)
            fireView.isHidden = false
            let beFireViewPoint = fireView.frame.origin
        let startPoint = firePoint.startPoint
            let curve1Point = firePoint.curve1Point
            let curve2Point = firePoint.curve2Point
            let endPoint = firePoint.endPoint
            
            path.move(to: startPoint)
            path.addCurve(to: endPoint, controlPoint1: curve1Point, controlPoint2: curve2Point)
            
            let a = Int(arc4random_uniform(3))
            fireView.backgroundColor = AddFireAssistent.sparkColorSet[a]
            //        self.view.addSubview(fireView)
            CATransaction.begin()
            
            
            // Position
            let positionAnim = CAKeyframeAnimation(keyPath: "position")
            positionAnim.path = path.cgPath
            positionAnim.calculationMode = CAAnimationCalculationMode.linear
            positionAnim.rotationMode = CAAnimationRotationMode.rotateAuto
            positionAnim.duration = timeInterval
            
            // Scale
            //        let randomMaxScale = 1.0 + CGFloat(arc4random_uniform(7)) / 10.0
            //        let randomMinScale = 0.5 + CGFloat(arc4random_uniform(3)) / 10.0
            let randomMaxScale : CGFloat = 1.0
            let randomMinScale : CGFloat = 0.2
            
            let fromTransform = CATransform3DIdentity
            let byTransform = CATransform3DScale(fromTransform, randomMaxScale, randomMaxScale, randomMaxScale)
            let toTransform = CATransform3DScale(CATransform3DIdentity, randomMinScale, randomMinScale, randomMinScale)
            let transformAnim = CAKeyframeAnimation(keyPath: "transform")
            
            transformAnim.values = [
                NSValue(caTransform3D: fromTransform),
                NSValue(caTransform3D: byTransform),
                NSValue(caTransform3D: byTransform),
                NSValue(caTransform3D: toTransform)
            ]
            transformAnim.keyTimes = [0.0, 0.2, 0.5, 0.95]
            transformAnim.duration = timeInterval
            transformAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            fireView.layer.transform = toTransform
            
            
            // Opacity
            let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
            opacityAnim.values = [1.0, 0.0]
            opacityAnim.keyTimes = [0.9, 1]
            opacityAnim.duration = timeInterval
            fireView.layer.opacity = 0.0
            
            // Group
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [positionAnim, transformAnim, opacityAnim]
            groupAnimation.duration = timeInterval
            
            CATransaction.setCompletionBlock({
                fireView.layer.removeAllAnimations()
                fireView.removeFromSuperview()
            })
            
            fireView.layer.add(groupAnimation, forKey: nil )
            
            CATransaction.commit()
        }
    
    
    
    
    
    
    
//    @objc private func timerDidFire() {
//
//        let timeInterval : CFTimeInterval = 0.6
//        //https://www.desmos.com/calculator/epunzldltu
////        let paths : [(curve1Point: CGPoint , curve2Point : CGPoint , endPoint : CGPoint)] = [
////            (curve1Point: CGPoint(x: 80, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 178, y: 400)),
////            (curve1Point: CGPoint(x: 91, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 278, y: 400)),
////            (curve1Point: CGPoint(x: 99, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 200, y: 700)),
////            (curve1Point: CGPoint(x: 110, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 150, y: 400)),
////            (curve1Point: CGPoint(x: 75, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 133, y: 400)),
////            (curve1Point: CGPoint(x: 87, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 300, y: 400)),
////        ]
//
//
//
//        let paths : [(curve1Point: CGPoint , curve2Point : CGPoint , endPoint : CGPoint)] = [
//            (curve1Point: CGPoint(x: 80, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 178, y: 400)),
//            (curve1Point: CGPoint(x: 91, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 278, y: 400)),
//            (curve1Point: CGPoint(x: 99, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 200, y: 700)),
//            (curve1Point: CGPoint(x: 110, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 150, y: 400)),
//            (curve1Point: CGPoint(x: 75, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 133, y: 400)),
//            (curve1Point: CGPoint(x: 87, y: 33) , curve2Point : CGPoint(x: 146, y: 42) , endPoint : CGPoint(x: 300, y: 400)),
//        ]
//        let path = UIBezierPath()
//        let fireView  = VVVV(frame: CGRect(x: 50, y: 100, width: 44, height: 44))
//        fireView.layer.cornerRadius = 22
//        UIApplication.shared.keyWindow?.addSubview(fireView)
//        fireView.isHidden = false
//        let beFireViewPoint = fireView.frame.origin
//        let startPoint = CGPoint(x: beFireViewPoint.x , y: beFireViewPoint.y)
//        let curve1Point = paths[Int(arc4random_uniform(5))].curve1Point
//        let curve2Point = paths[Int(arc4random_uniform(5))].curve2Point
//        let endPoint = paths[Int(arc4random_uniform(5))].endPoint
//
//        path.move(to: startPoint)
//        path.addCurve(to: endPoint, controlPoint1: curve1Point, controlPoint2: curve2Point)
//
//        let a = Int(arc4random_uniform(3))
//        fireView.backgroundColor = ViewController.sparkColorSet[a]
//        //        self.view.addSubview(fireView)
//        CATransaction.begin()
//
//
//        // Position
//        let positionAnim = CAKeyframeAnimation(keyPath: "position")
//        positionAnim.path = path.cgPath
//        positionAnim.calculationMode = CAAnimationCalculationMode.linear
//        positionAnim.rotationMode = CAAnimationRotationMode.rotateAuto
//        positionAnim.duration = timeInterval
//
//
//        // Scale
//        //        let randomMaxScale = 1.0 + CGFloat(arc4random_uniform(7)) / 10.0
//        //        let randomMinScale = 0.5 + CGFloat(arc4random_uniform(3)) / 10.0
//        let randomMaxScale : CGFloat = 1.0
//        let randomMinScale : CGFloat = 0.2
//
//        let fromTransform = CATransform3DIdentity
//        let byTransform = CATransform3DScale(fromTransform, randomMaxScale, randomMaxScale, randomMaxScale)
//        let toTransform = CATransform3DScale(CATransform3DIdentity, randomMinScale, randomMinScale, randomMinScale)
//        let transformAnim = CAKeyframeAnimation(keyPath: "transform")
//
//        transformAnim.values = [
//            NSValue(caTransform3D: fromTransform),
//            NSValue(caTransform3D: byTransform),
//            NSValue(caTransform3D: byTransform),
//            NSValue(caTransform3D: toTransform)
//        ]
//        transformAnim.keyTimes = [0.0, 0.2, 0.5, 0.95]
//        transformAnim.duration = timeInterval
//        transformAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//        fireView.layer.transform = toTransform
//
//
//        // Opacity
//        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
//        opacityAnim.values = [1.0, 0.0]
//        opacityAnim.keyTimes = [0.9, 1]
//        opacityAnim.duration = timeInterval
//        fireView.layer.opacity = 0.0
//
//        // Group
//        let groupAnimation = CAAnimationGroup()
//        groupAnimation.animations = [positionAnim, transformAnim, opacityAnim]
//        groupAnimation.duration = timeInterval
//
//        CATransaction.setCompletionBlock({
//            fireView.layer.removeAllAnimations()
//            fireView.removeFromSuperview()
//        })
//
//        fireView.layer.add(groupAnimation, forKey: nil )
//
//        CATransaction.commit()
//    }
    
}
extension AddFireAssistent{
    func startFireFlowerWithTouches(touches : Set<UITouch>){
        
        let touch : UITouch = touches.first!;
        let p  = touch.location(in: UIApplication.shared.keyWindow!)
        
        let timeInterval : CFTimeInterval = 0.6
        //https://www.desmos.com/calculator/epunzldltu
        
        for firePoint in fireFlow {
            var firePoint = firePoint
            var s = firePoint.multiply(by: 555)
            firePoint = s.add(vector: CGVector(dx: p.x, dy: p.y))
            
            
            let path = UIBezierPath()
            let fireView  = VVVV(frame: CGRect(x: 50, y: 100, width: 28, height: 22))
            fireView.layer.cornerRadius = 14
            UIApplication.shared.keyWindow?.addSubview(fireView)
            fireView.isHidden = false
            let beFireViewPoint = fireView.frame.origin
            let startPoint = firePoint.startPoint
            let curve1Point = firePoint.curve1Point
            let curve2Point = firePoint.curve2Point
            let endPoint = firePoint.endPoint
            
            path.move(to: startPoint)
            path.addCurve(to: endPoint, controlPoint1: curve1Point, controlPoint2: curve2Point)
            
            let a = Int(arc4random_uniform(3))
            fireView.backgroundColor = AddFireAssistent.sparkColorSet[a]
            //        self.view.addSubview(fireView)
            CATransaction.begin()
            
            
            // Position
            let positionAnim = CAKeyframeAnimation(keyPath: "position")
            positionAnim.path = path.cgPath
            positionAnim.calculationMode = CAAnimationCalculationMode.linear
            positionAnim.rotationMode = CAAnimationRotationMode.rotateAuto
            positionAnim.duration = timeInterval
            
            // Scale
            //        let randomMaxScale = 1.0 + CGFloat(arc4random_uniform(7)) / 10.0
            //        let randomMinScale = 0.5 + CGFloat(arc4random_uniform(3)) / 10.0
            let randomMaxScale : CGFloat = 1.0
            let randomMinScale : CGFloat = 0.2
            
            let fromTransform = CATransform3DIdentity
            let byTransform = CATransform3DScale(fromTransform, randomMaxScale, randomMaxScale, randomMaxScale)
            let toTransform = CATransform3DScale(CATransform3DIdentity, randomMinScale, randomMinScale, randomMinScale)
            let transformAnim = CAKeyframeAnimation(keyPath: "transform")
            
            transformAnim.values = [
                NSValue(caTransform3D: fromTransform),
                NSValue(caTransform3D: byTransform),
                NSValue(caTransform3D: byTransform),
                NSValue(caTransform3D: toTransform)
            ]
            transformAnim.keyTimes = [0.0, 0.2, 0.5, 0.95]
            transformAnim.duration = timeInterval
            transformAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            fireView.layer.transform = toTransform
            
            
            // Opacity
            let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
            opacityAnim.values = [1.0, 0.0]
            opacityAnim.keyTimes = [0.9, 1]
            opacityAnim.duration = timeInterval
            fireView.layer.opacity = 0.0
            
            // Group
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [positionAnim, transformAnim, opacityAnim]
            groupAnimation.duration = timeInterval
            
            CATransaction.setCompletionBlock({
                fireView.layer.removeAllAnimations()
                fireView.removeFromSuperview()
            })
            
            fireView.layer.add(groupAnimation, forKey: nil )
            
            CATransaction.commit()
        }
    }
    
    
        
//        fireFlow
    
    
}
class VVVV: UIView {
    deinit {
        print("销毁")
    }
}
extension CGPoint {

    mutating func add(vector: CGVector) {
        self.x += vector.dx
        self.y += vector.dy
    }

    func adding(vector: CGVector) -> CGPoint {
        var copy = self
        copy.add(vector: vector)
        return copy
    }

    mutating func multiply(by value: CGFloat) {
        self.x *= value
        self.y *= value
    }
}

