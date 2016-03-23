//
//  AppWindow.swift
//  Pods
//
//  Created by Joseph Blau on 3/22/16.
//
//

import UIKit

public class AppWindow: UIWindow {

    var ovalView: UIView = {
        let view = UIView(frame: CGRectMake(0,0,40,40))
        view.layer.backgroundColor = UIColor.redColor().CGColor
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.redColor().CGColor
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.opacity = 0.1
        return view
    }()
    
    var overlayWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.userInteractionEnabled = false
        window.windowLevel = UIWindowLevelStatusBar
        window.backgroundColor = .clearColor()
        window.hidden = false
        window.rootViewController = UIViewController()
        return window
    }()
    
    // MARK: - Initializers
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Handle Events
    
    public override func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        guard let touches = event.allTouches() else {
            return
        }
        
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        for touch in touches {
            switch touch.phase {
            case .Began:
                ovalView.center = touch.locationInView(self.window)
                overlayWindow.addSubview(ovalView)

                let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                opacityAnimation.toValue = 0.7
                
                let borderAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderAnimation.toValue = 24
                
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.toValue = 0.4
                
                let group = CAAnimationGroup()
                group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                group.duration = 0.1
                group.removedOnCompletion = false
                group.fillMode = kCAFillModeForwards
                group.animations = [borderAnimation, scaleAnimation, opacityAnimation]
                
                ovalView.layer.addAnimation(group, forKey: "touchZoomIn")
            case .Moved:
                print("moved")
                ovalView.center = touch.locationInView(self.window)
            case .Stationary:
                print("stationary")
            case .Ended, .Cancelled:
                ovalView.layer.backgroundColor = UIColor.clearColor().CGColor
                let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                opacityAnimation.toValue = 0.2
                
                let borderAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderAnimation.toValue = 0
                
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.toValue = 1.4
                
                let group = CAAnimationGroup()
                group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                group.duration = 0.3
                group.removedOnCompletion = false
                group.fillMode = kCAFillModeForwards
                group.animations = [borderAnimation, scaleAnimation, opacityAnimation]
                
                ovalView.layer.addAnimation(group, forKey: "touchZoomOut")
            }
        }
    }
}
