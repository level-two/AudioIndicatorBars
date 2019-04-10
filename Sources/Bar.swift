//
//  Bar.swift
//  Pods
//
//  Created by Leonardo Cardoso on 16/09/2016.
//
//

import Foundation
import UIKit

class BarView: UIView {
    public var tempo: Double = 120.0 {
        didSet {
            animationSpeed = 60.0 / tempo
        }
    }
    
    public init(
        _ barFrame: CGRect,
        _ cornerRadius: CGFloat = 0.0,
        _ color: UIColor = UIColor.black,
        _ minHeight: CGFloat = 0.0,
        _ maxHeight: CGFloat = 0.0
        ) {
        
        self.barFrame = barFrame
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        
        super.init(frame: barFrame)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.backgroundColor = color
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        animationTimer?.invalidate()
    }
    
    fileprivate var barFrame: CGRect = .zero
    fileprivate var animationSpeed: Double = 1.0
    fileprivate var minHeight: CGFloat = 0.0
    fileprivate var maxHeight: CGFloat = 0.0
    fileprivate var animationTimer: Timer?
    fileprivate var animationDir: Bool = false
}

extension BarView {
    public func startAnimation() {
        guard animationTimer == nil else { return }
        
        animationTimer = Timer.scheduledTimer( timeInterval: animationSpeed/2, target: self, selector: #selector(BarView.performNextAnimationStep), userInfo: nil, repeats: true)
    }
    
    public func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        animationDir = false
    }
}

extension BarView {
    @objc func performNextAnimationStep() {
        let maxFrame = CGRect(x: barFrame.minX, y: barFrame.maxY - maxHeight, width: barFrame.width, height: maxHeight)
        let minFrame = CGRect(x: barFrame.minX, y: barFrame.maxY - minHeight, width: barFrame.width, height: minHeight)
        let targetFrame = animationDir ? maxFrame : minFrame
        UIView.animate(withDuration: animationSpeed/2, animations: { self.frame = targetFrame })
        animationDir = !animationDir
    }
}
