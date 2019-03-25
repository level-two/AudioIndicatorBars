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
    public init(
        _ frame: CGRect,
        _ cornerRadius: CGFloat = 0.0,
        _ color: UIColor = UIColor.black,
        _ minHeight: CGFloat = 0.0,
        _ maxHeight: CGFloat = 0.0
        ) {
        
        self.animationSpeed = Double.random(min: 0.5, max: 0.9)
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        
        super.init(frame: frame)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.backgroundColor = color
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    public func startAnimation() {
        guard !self.isAnimating else { return }
        isAnimating = true
        performAnimation()
    }
    
    public func stopAnimation() {
        isAnimating = false
    }
    
    func performAnimation() {
        guard isAnimating else { return }
        
        let maxFrame = CGRect(x: frame.minX, y: frame.maxY - maxHeight, width: frame.width, height: maxHeight)
        let minFrame = CGRect(x: frame.minX, y: frame.maxY - minHeight, width: frame.width, height: minHeight)
        
        UIView.animate(
            withDuration: animationSpeed,
            animations: { self.frame = maxFrame },
            completion: { finished in
                guard finished else { return }
                UIView.animate(
                    withDuration: self.animationSpeed,
                    animations: { self.frame = minFrame },
                    completion: { finished in
                        guard finished else { return }
                        self.performAnimation()
                })
        })
    }
    
    fileprivate var animationSpeed: Double = 1.0
    fileprivate var minHeight: CGFloat = 0.0
    fileprivate var maxHeight: CGFloat = 0.0
    fileprivate var isAnimating: Bool = false
}
