//
//  AppWindow.swift
//  Pods
//
//  Created by Joseph Blau on 3/22/16.
//
//

import UIKit

private struct AnimationSettings {
    let opacityTo: CGFloat
    let borderWidthTo: CGFloat
    let scaleTo: CGFloat
    let duration: TimeInterval
}

public protocol AppWindowDelegate {
    func touchColor() -> UIColor?
}

public class AppWindow: UIWindow {
    
    private var visualizationWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main().bounds)
        window.isUserInteractionEnabled = false
        window.windowLevel = UIWindowLevelStatusBar
        window.backgroundColor = .clear()
        window.isHidden = false
        window.rootViewController = UIViewController()
        return window
    }()
    private let animationGroup: CAAnimationGroup = {
        let group = CAAnimationGroup()
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        return group
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
    
    public override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        guard let touches = event.allTouches() else {
            return
        }
        
        for touch in touches {
            handleTouchVisualization(touch)
        }
    }
    
    // MARK: - Private
    private func handleTouchVisualization(_ touch: UITouch) {
        switch touch.phase {
        case .began:
            createTouchVisualization(touch)
        case .moved:
            moveTouchVisualization(touch)
        case .stationary:
            break
        case .ended, .cancelled:
            removeTouchVisualization(touch)
        }
    }
    
    private func createTouchVisualization(_ touch: UITouch) {
        let touchPointView = self.newTouchPointView()
        touchPointView.center = touch.location(in: self.window)
        
        touchPointViews[touch] = touchPointView
        visualizationWindow.addSubview(touchPointView)
        
        let animationSettings = AnimationSettings(opacityTo: 0.7, borderWidthTo: 24, scaleTo: 0.4, duration: 0.1)
        let group = generateBasicAnimations(animationSettings)
        touchPointView.layer.add(group, forKey: "touchZoomIn")
    }
    
    private func moveTouchVisualization(_ touch: UITouch) {
        guard let touchView = touchPointViews[touch] else {
            return
        }
        touchView.center = touch.location(in: self.window)
    }
    
    private func removeTouchVisualization(_ touch: UITouch) {
        touchPointViews[touch]?.layer.backgroundColor = UIColor.clear().cgColor
        
        let animationSettings = AnimationSettings(opacityTo: 0.2, borderWidthTo: 0, scaleTo: 1.4, duration: 0.3)
        let group = generateBasicAnimations(animationSettings)
        touchPointViews[touch]?.layer.add(group, forKey: "touchZoomOut")
        touchPointViews.removeValue(forKey: touch)
    }
    
    
    private func generateBasicAnimations(_ settings: AnimationSettings) -> CAAnimationGroup {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = settings.opacityTo
        
        let borderAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderAnimation.toValue = settings.borderWidthTo
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = settings.scaleTo
        
        animationGroup.duration = settings.duration
        animationGroup.animations = [borderAnimation, scaleAnimation, opacityAnimation]
        return animationGroup
    }
    
    private func newTouchPointView() -> UIView {
        let view = UIView(frame: CGRect(x: 0,y: 0,width: 64,height: 64))
        view.layer.backgroundColor = delegate?.touchColor()?.cgColor ?? view.tintColor.cgColor
            UIColor.red().cgColor
        view.layer.borderWidth = 1
        view.layer.borderColor = delegate?.touchColor()?.cgColor ?? view.tintColor.cgColor
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.opacity = 0.1
        return view
    }
}
