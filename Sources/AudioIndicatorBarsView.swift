//
//  AudioIndicatorBars.swift
//  AudioIndicatorBars
//
//  Created by Leonardo Cardoso on 16/09/2016.
//  Copyright © 2016 leocardz.com. All rights reserved.
//

import Foundation
import UIKit

open class AudioIndicatorBarsView: UIView {
    public init(
        _ frame: CGRect,
        _ barsCount: Int = 4,
        _ barsCornerRadius: CGFloat = 0.0,
        _ relativeBarWidth : CGFloat = 0.5,
        _ color: UIColor = UIColor.white) {
        
        super.init(frame: frame)
        
        let sectionsWidth = bounds.width / CGFloat(barsCount)
        for i in 0 ..< barsCount {
            let barFrame =
                CGRect(x: sectionsWidth * CGFloat(i), y: 0, width: sectionsWidth, height: frame.height)
                    .insetBy(dx: sectionsWidth*(1-relativeBarWidth)/2, dy: 0)
            
            let bar = BarView(barFrame, barsCornerRadius, color, frame.height*0.2, frame.height)
            self.barsSet.append(bar)
            self.addSubview(bar)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open func startAnimation() {
        for bar in self.barsSet { bar.startAnimation() }
    }
    
    open func stopAnimation() {
        for bar in self.barsSet { bar.stopAnimation() }
    }
    
    fileprivate var barsSet: [BarView] = []
}
