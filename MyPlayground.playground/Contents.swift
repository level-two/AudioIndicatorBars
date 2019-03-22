//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

@IBDesignable
open class AudioIndicatorBarsView: UIView {
    @IBInspectable public var barsCount : Int = 4 { didSet { setNeedsLayout() }}
    @IBInspectable public var cornerRadius : CGFloat = 0 { didSet { setNeedsLayout() }}
    @IBInspectable public var relativeBarWidth : CGFloat = 0.5 { didSet { setNeedsLayout() }}
    @IBInspectable public var barsColor : UIColor = UIColor.white { didSet { setNeedsLayout() }}
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(
        _ frame: CGRect,
        _ barsCount: Int = 4,
        _ barsCornerRadius: CGFloat = 0.0,
        _ relativeBarWidth : CGFloat = 0.5,
        _ color: UIColor = UIColor.white) {
        
        self.barsCount = barsCount
        self.cornerRadius = barsCornerRadius
        self.relativeBarWidth = relativeBarWidth
        self.barsColor = color
        
        super.init(frame: frame)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        barsSet.forEach { $0.removeFromSuperview() }
        barsSet = []
        
        let sectionsWidth = bounds.width / CGFloat(barsCount)
        for i in 0 ..< self.barsCount {
            let barFrame =
                CGRect(x: sectionsWidth * CGFloat(i), y: 0, width: sectionsWidth, height: bounds.height)
                    .insetBy(dx: sectionsWidth*(1-relativeBarWidth)/2, dy: 0)
            let bar = BarView(barFrame, cornerRadius, barsColor, bounds.height*0.2, bounds.height)
            self.barsSet.append(bar)
            self.addSubview(bar)
        }
    }
    
    open func startAnimation() {
        for bar in self.barsSet { bar.startAnimation() }
    }
    
    open func stopAnimation() {
        for bar in self.barsSet { bar.stopAnimation() }
    }
    
    static let barsOffset: CGFloat = 0.5
    fileprivate var barsSet: [BarView] = []
}


class BarView: UIView {
    public init(
        _ rect: CGRect,
        _ cornerRadius: CGFloat = 0.0,
        _ color: UIColor = UIColor.black,
        _ minHeight: CGFloat = 0.0,
        _ maxHeight: CGFloat = 0.0
        ) {
        
        self.animationSpeed = Double.random(min: 0.5, max: 0.9)
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        
        super.init(frame: rect)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.backgroundColor = color
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func startAnimation() {
        stopAnimation()
        
        var f = self.frame
        f.size.height = maxHeight
        self.frame = f
        
        f.size.height = minHeight
        UIView.animate(withDuration: animationSpeed, delay: 0, options: [.autoreverse, .repeat], animations: { [weak self] in self?.frame = f })
    }
    
    public func stopAnimation() {
        self.layer.removeAllAnimations()
    }
    
    fileprivate var animationSpeed: Double = 1.0
    fileprivate var minHeight: CGFloat = 0.0
    fileprivate var maxHeight: CGFloat = 0.0
    fileprivate var doAnimate: Bool = false
    fileprivate var isAnimating: Bool = false
}


public extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random:Double {
        get {
            return Double(arc4random()) / 0xFFFFFFFF
        }
    }
    
    /**
     Create a random number Double
     
     - parameter min: Double
     - parameter max: Double
     
     - returns: Double
     */
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}


class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let barsFrame = CGRect(x: 100, y: 100, width: 100, height: 200)
        let bars = AudioIndicatorBarsView(barsFrame, 1, 5, 0.2, .black)
        bars.backgroundColor = .green
        
        view.addSubview(bars)
        self.view = view
        
        bars.startAnimation()
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
