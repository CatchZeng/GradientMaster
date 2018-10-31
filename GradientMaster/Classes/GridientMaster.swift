//
//  GridientMaster.swift
//  GradientMaster
//
//  Created by CatchZeng on 2018/10/31.
//

import Foundation

@objc public enum Mode: Int {
    case linear
    case radial
}

@objc public enum Direction: Int {
    case vertical
    case horizontal
}

extension Direction {
    fileprivate func end(size: CGSize) -> CGPoint {
        switch self {
        case .horizontal:
            return CGPoint(x: size.width, y: 0.0)
        case .vertical:
            return CGPoint(x: 0.0, y: size.height)
        }
    }
}

open class GradientLayer: CALayer {
    
    open var mode: Mode = .linear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var direction: Direction = .vertical {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var colors: [UIColor] = defaultColors {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var locations: [CGFloat]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    open override func draw(in ctx: CGContext) {
        ctx.saveGState()
        drawGradient(ctx: ctx, mode: mode, colors: colors, direction: direction, locations: locations, bounds: bounds)
    }
}

open class GradientView: UIView {
    @IBInspectable open var mode: Mode = .linear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable open var direction: Direction = .vertical {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var colors: [UIColor] = defaultColors {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var locations: [CGFloat]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext() {
            drawGradient(ctx: ctx, mode: mode, colors: colors, direction: direction, locations: locations, bounds: bounds)
        }
    }
}

fileprivate let defaultColors = [UIColor(red: 24.0/255.0, green: 224.0/255.0, blue: 218.0/255.0, alpha: 1.0),
                                 UIColor(red: 15.0/255.0, green: 101.0/255.0, blue: 173.0/255.0, alpha: 1.0)]

fileprivate func drawGradient(ctx: CGContext,
                              mode: Mode,
                              colors: [UIColor],
                              direction: Direction,
                              locations: [CGFloat]?,
                              bounds: CGRect) {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let cgColors = colors.map({ (color) -> CGColor in
        return color.cgColor
    })
    guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations) else {
        return
    }
    
    switch mode {
    case .linear:
        let start = CGPoint.zero
        let end = direction.end(size: bounds.size)
        ctx.drawLinearGradient(gradient,
                               start: start,
                               end: end,
                               options: .drawsAfterEndLocation)
        
    case .radial:
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        ctx.drawRadialGradient(gradient,
                               startCenter: center,
                               startRadius: 0,
                               endCenter: center,
                               endRadius: min(bounds.size.width, bounds.size.height) / 2,
                               options: .drawsAfterEndLocation)
    }
}
