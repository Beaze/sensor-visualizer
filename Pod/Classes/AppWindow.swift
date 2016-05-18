//
//  AppWindow.swift
//  Pods
//
//  Created by Joseph Blau on 3/22/16.
//
//

import UIKit

public protocol AppWindowDelegate {
    func touchColor() -> UIColor?
}

public class AppWindow: UIWindow {
    
    private var visualizationWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.userInteractionEnabled = false
        window.windowLevel = UIWindowLevelStatusBar
        window.backgroundColor = .clearColor()
        window.hidden = false
        window.rootViewController = UIViewController()
        return window
    }()
    private var touchPointViews = [UITouch: UIView]()
    public var delegate: AppWindowDelegate?
    
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
        
        for touch in touches {
            handleTouchVisualization(touch)
        }
    }
    
    // MARK: - Private
    private func handleTouchVisualization(touch: UITouch) {
        switch touch.phase {
        case .Began:
            createTouchVisualization(touch)
        case .Moved:
            moveTouchVisualization(touch)
        case .Stationary:
            break
        case .Ended, .Cancelled:
            removeTouchVisualization(touch)
        }
    }
    
    private func createTouchVisualization(touch: UITouch) {
        let touchPointView = self.newTouchPointView()
        touchPointView.center = touch.locationInView(self.window)
        
        touchPointViews[touch] = touchPointView
        visualizationWindow.addSubview(touchPointView)
        
        let group = generateBasicAnimations(0.7, borderWidthTo: 24, scaleTo: 0.4, duration: 0.1)
        touchPointView.layer.addAnimation(group, forKey: "touchZoomIn")
    }
    
    private func moveTouchVisualization(touch: UITouch) {
        guard let touchView = touchPointViews[touch] else {
            return
        }
        touchView.center = touch.locationInView(self.window)
    }
    
    private func removeTouchVisualization(touch: UITouch) {
        touchPointViews[touch]?.layer.backgroundColor = UIColor.clearColor().CGColor
        
        let group = generateBasicAnimations(0.2, borderWidthTo: 0, scaleTo: 1.4, duration: 0.3)
        touchPointViews[touch]?.layer.addAnimation(group, forKey: "touchZoomOut")
        touchPointViews.removeValueForKey(touch)
    }
    
    
    private func generateBasicAnimations(opacityTo: CGFloat, borderWidthTo: CGFloat, scaleTo: CGFloat, duration: NSTimeInterval) -> CAAnimationGroup {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = opacityTo
        
        let borderAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderAnimation.toValue = borderWidthTo
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = scaleTo
        
        let group = CAAnimationGroup()
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        group.duration = duration
        group.removedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.animations = [borderAnimation, scaleAnimation, opacityAnimation]
        return group
    }
    
    private func newTouchPointView() -> UIView {
        let view = UIView(frame: CGRectMake(0,0,64,64))
        view.layer.backgroundColor = delegate?.touchColor()?.CGColor ?? view.tintColor.CGColor
            UIColor.redColor().CGColor
        view.layer.borderWidth = 1
        view.layer.borderColor = delegate?.touchColor()?.CGColor ?? view.tintColor.CGColor
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.opacity = 0.1
        return view
    }
}
