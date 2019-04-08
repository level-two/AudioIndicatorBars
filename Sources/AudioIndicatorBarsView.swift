//
//  AudioIndicatorBars.swift
//  AudioIndicatorBars
//
//  Created by Leonardo Cardoso on 16/09/2016.
//  Copyright © 2016 leocardz.com. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class AudioIndicatorBarsView: UIView {
    @IBInspectable public var barsCount : Int = 4 { didSet { redrawBars() }}
    @IBInspectable public var barsCornerRadius : CGFloat = 0 { didSet { redrawBars() }}
    @IBInspectable public var relativeBarWidth : CGFloat = 0.5 { didSet { redrawBars() }}
    @IBInspectable public var barsColor : UIColor = UIColor.white { didSet { redrawBars() }}
    
    override open var frame: CGRect { didSet { redrawBars() }}
    
    public init(
        _ frame: CGRect,
        _ barsCount: Int = 4,
        _ barsCornerRadius: CGFloat = 0.0,
        _ relativeBarWidth : CGFloat = 0.5,
        _ barsColor: UIColor = UIColor.white) {
        
        self.barsCount = barsCount
        self.barsColor = barsColor
        self.barsCornerRadius = barsCornerRadius
        self.relativeBarWidth = relativeBarWidth
        self.barsColor = barsColor
        
        super.init(frame: frame)
        
        redrawBars()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open func startAnimation() {
        isAnimating = true
        for bar in self.barsSet { bar.startAnimation() }
    }
    
    open func stopAnimation() {
        isAnimating = false
        for bar in self.barsSet { bar.stopAnimation() }
    }
    
    open func setTempo(_ tempo: Int) {
        self.tempo = tempo
        var rate = 0.25
        for bar in self.barsSet {
            bar.tempo = Double(tempo) * rate
            rate += 0.125
        }
    }
    
    fileprivate var barsSet = [BarView]()
    fileprivate var isAnimating = false
    fileprivate var tempo = 120
}

extension AudioIndicatorBarsView {
    override open func draw(_ rect: CGRect) {
        redrawBars()
    }
    
    func redrawBars() {
        barsSet.forEach { $0.removeFromSuperview() }
        barsSet.removeAll()
        
        let sectionsWidth = bounds.width / CGFloat(barsCount)
        for i in 0 ..< barsCount {
            let barFrame = CGRect(x: sectionsWidth * CGFloat(i), y: 0, width: sectionsWidth, height: frame.height)
                .insetBy(dx: sectionsWidth*(1-relativeBarWidth)/2, dy: 0)
            
            let bar = BarView(barFrame, barsCornerRadius, barsColor, frame.height*0.2, frame.height)
            self.barsSet.append(bar)
            self.addSubview(bar)
        }
        
        setTempo(tempo)
        if isAnimating {
            startAnimation()
        }
    }
}
