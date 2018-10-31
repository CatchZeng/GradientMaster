//
//  GradientMaster.swift
//  GradientMaster
//
//  Created by CatchZeng on 2018/10/31.
//

import Foundation

public enum Direction: Int {
    case vertical = 0
    case horizontal = 1
}

extension Direction {
    fileprivate var end: CGPoint {
        switch self {
        case .horizontal:
            return CGPoint(x: 1.0, y: 0.0)
        case .vertical:
            return CGPoint(x: 0.0, y: 1.0)
        }
    }
}

@IBDesignable
open class GradientMasterView: UIView {
    
    @IBInspectable open var ibDirection: Int = 0 {
        didSet {
            if let direction = Direction.init(rawValue: ibDirection) {
                self.direction = direction
            }
        }
    }
    
    @IBInspectable open var ibType: Int = 0 {
        didSet {
            if ibType == 0 {
                self.type = .axial
            } else if ibType == 1 {
                self.type = .radial
            } else {
                if #available(iOS 12.0, *) {
                    self.type = .conic
                } else {
                    print("conic is only for iOS 12.0.")
                }
            }
        }
    }
    
    @IBInspectable open var ibEffect: Int = 0 {
        didSet {
            if let effect = GradientEffect.init(rawValue: ibEffect) {
                self.effect = effect
            }
        }
    }
    
    open var effect: GradientEffect = .happy {
        didSet {
            self.colors = effect.colors
        }
    }
    
    open var type: CAGradientLayerType = .axial {
        didSet {
            gradientLayer.type = type
            gradientLayer.setNeedsDisplay()
        }
    }
    
    open var direction: Direction = .vertical {
        didSet {
            gradientLayer.endPoint = direction.end
            gradientLayer.setNeedsDisplay()
        }
    }
    
    open var colors: [UIColor] = GradientEffect.happy.colors {
        didSet {
            gradientLayer.colors = genCGColors()
            gradientLayer.setNeedsDisplay()
        }
    }
    
    public let gradientLayer = CAGradientLayer()
    
    open var animationDuration: TimeInterval = 5.0
    private struct Animation {
        static let keyPath = "colors"
        static let key = "ColorChange"
    }
    private var index: Int = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commInit()
    }
    
    private func commInit() {
        gradientLayer.colors = genCGColors()
        gradientLayer.drawsAsynchronously = true
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.setNeedsDisplay()
    }
    
    public func startAnimation() {
        gradientLayer.removeAllAnimations()
        animateGradient()
    }
    
    public func stopAnimation() {
        gradientLayer.removeAllAnimations()
    }
    
    fileprivate func animateGradient() {
        index += 1
        let animation = CABasicAnimation(keyPath: Animation.keyPath)
        animation.duration = animationDuration
        animation.toValue = genCGColors()
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        gradientLayer.add(animation, forKey: Animation.key)
    }
    
    fileprivate func genCGColors() -> [CGColor] {
        if colors.count < 2 { return [] }
        
        return [colors[index % colors.count].cgColor,
                colors[(index + 1) % colors.count].cgColor]
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        gradientLayer.removeAllAnimations()
        gradientLayer.removeFromSuperlayer()
    }
}

extension GradientMasterView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradientLayer.colors = genCGColors()
            animateGradient()
        }
    }
}
