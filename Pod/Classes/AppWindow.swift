//
//  AppWindow.swift
//  Pods
//
//  Created by Joseph Blau on 3/22/16.
//
//

import UIKit

private struct TouchAnimationSettings {
    let opacityTo: CGFloat
    let borderWidthTo: CGFloat
    let scaleTo: CGFloat
    let duration: TimeInterval
}

private struct ShakeAnimationSettings {
    let opacityTo: Float
    let pushIntensity: CGFloat
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
        window.rootViewController?.view.frame = UIScreen.main().bounds
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
    private var animator: UIDynamicAnimator?

    
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
    
    public override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            let animationSettings = ShakeAnimationSettings(opacityTo: 0.4, pushIntensity: 800)
            shakeViewEffect(animationSettings)
        }
    }
    
    // MARK: - Private
    
    // MARK: - Touch Section
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
        
        let animationSettings = TouchAnimationSettings(opacityTo: 0.7, borderWidthTo: 24, scaleTo: 0.4, duration: 0.1)
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
        
        let animationSettings = TouchAnimationSettings(opacityTo: 0.2, borderWidthTo: 0, scaleTo: 1.4, duration: 0.3)
        let group = generateBasicAnimations(animationSettings)
        touchPointViews[touch]?.layer.add(group, forKey: "touchZoomOut")
        touchPointViews.removeValue(forKey: touch)
    }
    
    
    private func generateBasicAnimations(_ settings: TouchAnimationSettings) -> CAAnimationGroup {
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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        view.layer.backgroundColor = delegate?.touchColor()?.cgColor ?? view.tintColor.cgColor
            UIColor.red().cgColor
        view.layer.borderWidth = 1
        view.layer.borderColor = delegate?.touchColor()?.cgColor ?? view.tintColor.cgColor
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.opacity = 0.1
        return view
    }
    
    // MARK: - Shake Section
    
    private func shakeViewEffect(_ settings: ShakeAnimationSettings) {
        guard let rootView = visualizationWindow.rootViewController?.view,
            let shakeViewLeft = shakeView(settings),
            let shakeViewRight = shakeView(settings) else {
            return
        }
        let shakeLeft: (view: UIView, direction: CGFloat) = (view: shakeViewLeft, direction: settings.pushIntensity)
        let shakeRight : (view: UIView, direction: CGFloat) = (view: shakeViewRight, direction: -settings.pushIntensity)
        let shakeViews = [shakeLeft, shakeRight]

        animator = UIDynamicAnimator(referenceView: rootView)
        
        for shakeView in shakeViews {
            let attachmentBehavior = shakeAttachmentBehavior(item: shakeView.view, attachedToAnchor: rootView.center)
            let pushBehavior = shakePushBehavior(items: [shakeView.view], direction: shakeView.direction)
            animator?.addBehavior(attachmentBehavior)
            animator?.addBehavior(pushBehavior)
            
            self.addSubview(shakeView.view)
            
            DispatchQueue.main.after(when: .now() + 2.0, execute: {
                shakeView.view.removeFromSuperview()
            })
        }
    }
    
    private func shakeView(_ settings: ShakeAnimationSettings) -> UIView? {
        guard let rootView = visualizationWindow.rootViewController?.view  else {
            return nil
        }
        
        let shakePathLayer = shakePathShapeLayer(rootView.bounds, settings.opacityTo)
        let shakeView = UIView(frame: rootView.bounds)
        shakeView.layer.addSublayer(shakePathLayer)
        rootView.addSubview(shakeView)
        return shakeView
    }
    
    private func shakePathShapeLayer(_ bounds: CGRect, _ opacityTo: Float) -> CAShapeLayer {
        let shakePath = UIBezierPath(rect: bounds.insetBy(dx: -100, dy: -100))
        let maskPath =  UIBezierPath(rect: bounds)
        shakePath.append(maskPath)
        shakePath.usesEvenOddFillRule = true
        
        let view = UIView(frame: bounds)
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = shakePath.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = delegate?.touchColor()?.cgColor ?? view.tintColor.cgColor
        fillLayer.opacity = opacityTo
        return fillLayer
    }
    
    // MARK: - UIDynamics Behaviors
    
    private func shakeAttachmentBehavior(item: UIDynamicItem, attachedToAnchor: CGPoint) -> UIAttachmentBehavior {
        let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: attachedToAnchor)
        attachmentBehavior.damping = 0.1
        attachmentBehavior.frequency = 10.0
        return attachmentBehavior
    }
    
    private func shakePushBehavior(items: [UIDynamicItem], direction: CGFloat) -> UIPushBehavior {
        let pushBehavior = UIPushBehavior(items: items, mode: .instantaneous)
        pushBehavior.pushDirection = CGVector(dx: direction, dy: 0)
        return pushBehavior
    }
}
