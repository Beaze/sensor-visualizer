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
        
        touchPointViews[touch]?.layer.addAnimation(group, forKey: "touchZoomOut")
        touchPointViews.removeValueForKey(touch)
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
