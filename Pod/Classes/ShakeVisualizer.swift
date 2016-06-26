//
//  ShakeVisualizer.swift
//  Pods
//
//  Created by Joseph Blau on 6/26/16.
//
//

import UIKit

private struct ShakeAnimationSettings {
    let rootView: UIView
    let opacityTo: Float
    let pushIntensity: CGFloat
    let touchColor: UIColor?
}

class ShakeVisualizer {
    
    // MARK: - Public
    
    func createShakeVisualization(rootView: UIView, animator: UIDynamicAnimator?, touchColor: UIColor?) {
        var animationSettings = ShakeAnimationSettings(rootView: rootView, opacityTo: 0.4, pushIntensity: 800, touchColor: touchColor)
        addShakeView(settings: animationSettings, animator: animator)
        
        animationSettings = ShakeAnimationSettings(rootView: rootView, opacityTo: 0.4, pushIntensity: -800, touchColor: touchColor)
        addShakeView(settings: animationSettings, animator: animator)
    }
    
    private func addShakeView(settings: ShakeAnimationSettings, animator: UIDynamicAnimator?) {
        let shakeView = shakeViewWithLayer(settings: settings)
        settings.rootView.addSubview(shakeView)
        
        animator?.addBehavior(shakeAttachmentBehavior(item: shakeView, attachedToAnchor: settings.rootView.center))
        animator?.addBehavior(shakePushBehavior(items: [shakeView], pushIntensity: settings.pushIntensity))
        
        DispatchQueue.main.after(when: .now() + 2.0, execute: {
            shakeView.removeFromSuperview()
        })
    }
    
    private func shakeViewWithLayer(settings: ShakeAnimationSettings) -> UIView {
        let shakePathLayer = shakePathShapeLayer(settings: settings)
        let shakeView = UIView(frame: settings.rootView.bounds)
        shakeView.layer.addSublayer(shakePathLayer)
        return shakeView
    }
    
    private func shakePathShapeLayer(settings: ShakeAnimationSettings) -> CAShapeLayer {
        let shakePath = UIBezierPath(rect: settings.rootView.bounds.insetBy(dx: -100, dy: -100))
        let maskPath =  UIBezierPath(rect: settings.rootView.bounds)
        shakePath.append(maskPath)
        shakePath.usesEvenOddFillRule = true
        
        let view = UIView(frame: settings.rootView.bounds)
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = shakePath.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = settings.touchColor?.cgColor ?? view.tintColor.cgColor
        fillLayer.opacity = settings.opacityTo
        return fillLayer
    }
    
    // MARK: - UIDynamics Behaviors
    
    private func shakeAttachmentBehavior(item: UIDynamicItem, attachedToAnchor: CGPoint) -> UIAttachmentBehavior {
        let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: attachedToAnchor)
        attachmentBehavior.damping = 0.1
        attachmentBehavior.frequency = 10.0
        return attachmentBehavior
    }
    
    private func shakePushBehavior(items: [UIDynamicItem], pushIntensity: CGFloat) -> UIPushBehavior {
        let pushBehavior = UIPushBehavior(items: items, mode: .instantaneous)
        pushBehavior.pushDirection = CGVector(dx: pushIntensity, dy: 0)
        return pushBehavior
    }
}
