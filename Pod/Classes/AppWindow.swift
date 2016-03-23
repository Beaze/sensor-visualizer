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
        let view = UIView(frame: CGRectMake(0,0,32,32))
        view.backgroundColor = .redColor()
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.greenColor().CGColor
        view.layer.cornerRadius = view.frame.height / 2
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
        configureWindow()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureWindow()
    }
    
    func configureWindow() {
        
    }
    
    // MARK: - Handle Events
    
    public override func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        guard let touches = event.allTouches() else {
            return
        }
        
        for touch in touches {
            switch touch.phase {
            case .Began:
                ovalView.center = touch.locationInView(self.window)
                overlayWindow.addSubview(ovalView)
                
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.ovalView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                    
                    }, completion: nil)

                
            case .Moved:
                ovalView.center = touch.locationInView(self.window)
            case .Stationary:
                print("stationary")
            case .Ended, .Cancelled:
                
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.ovalView.backgroundColor = .clearColor()
                    self.ovalView.layer.borderWidth = 0.6
                    self.ovalView.layer.borderColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.4).CGColor
                    self.ovalView.transform = CGAffineTransformMakeScale(1.4, 1.4)
                    
                    }, completion: { (Bool) in
                        self.ovalView.removeFromSuperview()
                        self.ovalView.backgroundColor = .redColor()
                        self.ovalView.layer.borderWidth = 10
                        self.ovalView.layer.borderColor = UIColor.greenColor().CGColor
                })
                
                
//                UIView.animateWithDuration(0.3, animations: {
//                    self.ovalView.transform =
//                }, completion:
                
            }
        }
    }
    
    
}
