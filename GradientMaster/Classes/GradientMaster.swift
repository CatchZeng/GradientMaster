//
//  GradientMaster.swift
//  GradientMaster
//
//  Created by CatchZeng on 2018/10/31.
//

import Foundation
import UIKit

public enum Direction: Int {
    case vertical = 0
    case horizontal = 1
}

extension Direction {
    fileprivate var start: CGPoint {
        switch self {
        case .vertical:
            return CGPoint(x: 0.0, y: 0.0)
        case .horizontal:
            return CGPoint(x: 0.0, y: 0.0)
        }
    }
    
    fileprivate var end: CGPoint {
        switch self {
        case .vertical:
            return CGPoint(x: 0.0, y: 1.0)
        case .horizontal:
            return CGPoint(x: 1.0, y: 0.0)
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
            gradientLayer.startPoint = direction.start
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
    
    public var animationDuration: TimeInterval = 3.0
    
    private struct Animation {
        static let keyPath = "colors"
        static let key = "ColorChange"
    }
    private var colorIndex: Int = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commInit()
    }
    
    private func commInit() {
        gradientLayer.colors = colors.map({ (color) -> CGColor in
            return color.cgColor
        })
        gradientLayer.drawsAsynchronously = true
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.setNeedsDisplay()
    }
    
    public func startAnimation() {
        gradientLayer.removeAllAnimations()
        gradientLayer.colors = genCGColors()
        gradientLayer.setNeedsDisplay()
        doAnimation()
    }
    
    public func stopAnimation() {
        gradientLayer.removeAllAnimations()
    }
    
    fileprivate func doAnimation() {
        colorIndex += 1
        let animation = CABasicAnimation(keyPath: Animation.keyPath)
        animation.duration = animationDuration
        animation.toValue = genCGColors()
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        gradientLayer.add(animation, forKey: Animation.key)
    }
    
    fileprivate func genCGColors() -> [CGColor] {
        let count = colors.count
        if count < 2 {
            return []
        }
        
        let color1 = colors[colorIndex % count].cgColor
        let color2 = colors[(colorIndex + 1) % count].cgColor
        return [color1, color2]
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
            doAnimation()
        }
    }
}
