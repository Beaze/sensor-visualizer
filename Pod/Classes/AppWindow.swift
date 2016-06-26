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
    
    private let touchVisualizer = TouchVisualizer()
    private let shakeVissualizer = ShakeVisualizer()
    
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
            handleTouchVisualization(touch: touch)
        }
    }
    
    public override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            handleShakeVisualizer()
        }
    }
    
    // MARK: - Private
    
    private func handleTouchVisualization(touch: UITouch) {
        guard let rootView = visualizationWindow.rootViewController?.view else {
            return
        }
        
        switch touch.phase {
        case .began:
            touchVisualizer.createTouchVisualization(rootView: rootView, touch: touch, touchColor: delegate?.touchColor())
        case .moved:
            touchVisualizer.moveTouchVisualization(rootView: rootView, touch: touch)
        case .stationary:
            break
        case .ended, .cancelled:
            touchVisualizer.removeTouchVisualization(touch: touch)
        }
    }
    
    private func handleShakeVisualizer() {
        guard let rootView = visualizationWindow.rootViewController?.view else {
            return
        }
        animator = UIDynamicAnimator(referenceView: rootView)
        shakeVissualizer.createShakeVisualization(rootView: rootView, animator: animator, touchColor: delegate?.touchColor())
    }
}
