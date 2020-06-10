//
//  SpringIndicator.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension Double {
    static let pi_2 = pi / 2
    static let pi_4 = pi / 4
}

extension CAPropertyAnimation {
    enum Key: String {
        case strokeStart = "strokeStart"
        case strokeEnd = "strokeEnd"
        case strokeColor = "strokeColor"
        case rotationZ = "transform.rotation.z"
        case scale = "transform.scale"
    }

    convenience init(key: Key) {
        self.init(keyPath: key.rawValue)
    }
}

enum AnimationProcess {
    case begin, during, skip

    func startAngle() -> Double {
        switch self {
        case .during:       return Double.pi_4
        case .begin, .skip: return 0
        }
    }

    func fromAngle() -> Double {
        switch self {
        case .during:       return -(Double.pi + Double.pi_2)
        case .begin, .skip: return -(Double.pi * 2 + Double.pi_2)
        }
    }

    func toAngle() -> Double {
        switch self {
        case .during:       return Double.pi
        case .begin, .skip: return 0
        }
    }
}

extension CALayer {
    enum ProgressViewAnimation: String {
        case rotation = "rotationAnimation"
        case expand = "expandAnimation"
        case spring = "springAnimation"
        case color = "colorAnimation"
        case scale = "scaleAnimation"
    }

    func add(_ anim: CAAnimation, for key: ProgressViewAnimation) {
        add(anim, forKey: key.rawValue)
    }

    func removeAnimation(for key: ProgressViewAnimation) {
        removeAnimation(forKey: key.rawValue)
    }

    func animation(for key: ProgressViewAnimation) -> CAAnimation? {
        return animation(forKey: key.rawValue)
    }

    func animationExist(for key: ProgressViewAnimation) -> Bool {
        return animation(forKey: key.rawValue) != nil
    }
}

open class SpringIndicatorView: UIView {
    deinit {
        stopAnimation()
    }

    let indicatorView: UIView
    fileprivate var pathLayer: CAShapeLayer? {
        didSet {
            oldValue?.removeAllAnimations()
            oldValue?.removeFromSuperlayer()

            if let layer = pathLayer {
                indicatorView.layer.addSublayer(layer)
            }
        }
    }

    /// Start the animation automatically in drawRect.
    @IBInspectable open var animating: Bool = false
    /// Line thickness.
    @IBInspectable open var lineWidth: CGFloat = 2
    /// Line Color. Default is gray.
    @IBInspectable open var lineColor: UIColor = .orange
    /// Line Colors. If set, lineColor is not used.
    open var lineColors: [UIColor] = []
    /// Cap style. Options are `round' and `square'. true is `round`. Default is false
    @IBInspectable open var lineCap: Bool = false
    /// Rotation duration. Default is 1.5
    @IBInspectable open var rotationDuration: Double = 1
    private var strokeDuration: Double {
        return rotationDuration / 2
    }

    /// During stroke animation is true.
    open var isSpinning: Bool {
        return pathLayer?.animationExist(for: .spring) == true
    }

    public override init(frame: CGRect) {
        indicatorView = UIView(frame: CGRect(origin: .zero, size: frame.size))
        super.init(frame: frame)
        indicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(indicatorView)

        let logoImageView = UIImageView(image: R.image.launchScreenLogo())
        logoImageView.frame = CGRect(x: 8, y: 8, width: frame.width-16, height: frame.height-16)
        logoImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        logoImageView.contentMode = .scaleAspectFit
        addSubview(logoImageView)
        backgroundColor = UIColor.clear

    }

    public required init?(coder aDecoder: NSCoder) {
        indicatorView = UIView()
        super.init(coder: aDecoder)
        indicatorView.frame = bounds
        indicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(indicatorView)

        let logoImageView = UIImageView(image: R.image.launchScreenLogo())
        logoImageView.frame = CGRect(x: 8, y: 8, width: frame.width-16, height: frame.height-16)
        logoImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        logoImageView.contentMode = .scaleAspectFit
        addSubview(logoImageView)
        backgroundColor = UIColor.clear
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        if animating {
            start(for: .begin)
        }
    }

    private func makeRotationPath(for process: AnimationProcess) -> UIBezierPath {
        let start = CGFloat(process.startAngle())
        let end = CGFloat(Double.pi + Double.pi_2) + start
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = max(bounds.width, bounds.height) / 2

        let arc = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        arc.lineWidth = 0

        return arc
    }

    private func makeRotationLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = (lineColors.first ?? lineColor).cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = lineCap ? .round : .square

        return shapeLayer
    }

    public func startAnimation() {
        start(for: .begin)
    }

    fileprivate func start(for process: AnimationProcess) {
        if isSpinning {
            return
        }

        indicatorView.layer.add(rotationAnimation(for: process), for: .rotation)
        strokeTransaction(process)
    }

    public func stopAnimation(_ waitingForAnimation: Bool = false) {
        if waitingForAnimation, let layer = pathLayer?.presentation() {
            let time = Double(2 - layer.strokeStart - layer.strokeEnd)
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                self.stopAnimation()
            }
        } else {
            indicatorView.layer.removeAllAnimations()
            pathLayer?.strokeEnd = 0
            pathLayer = nil
        }
    }

    private func strokeTransaction(_ process: AnimationProcess) {
        if pathLayer == nil {
            pathLayer = makeRotationLayer()
        }

        pathLayer?.path = makeRotationPath(for: process).cgPath

        CATransaction.begin()
        if process == .during {
            CATransaction.setCompletionBlock {
                self.pathLayer?.removeAllAnimations()
                self.start(for: .skip)
            }
        } else {
            if lineColors.count > 1 {
                pathLayer?.add(colorAnimation(for: process), for: .color)
            }
        }

        pathLayer?.add(nextAnimation(for: process), for: .spring)
        CATransaction.commit()
    }

    private func nextAnimation(for process: AnimationProcess) -> CAAnimation {
        return process == .during ? strokeAnimation(key: .strokeStart) : springAnimation()
    }

}

// MARK: - Animation
extension SpringIndicatorView {
    // MARK: for Rotation
    private func rotationAnimation(for process: AnimationProcess) -> CAPropertyAnimation {
        let animation = CABasicAnimation(key: .rotationZ)
        animation.duration = rotationDuration
        animation.repeatCount = HUGE
        animation.fromValue = process.fromAngle()
        animation.toValue = process.toAngle()
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        return animation
    }

    // MARK: for Spring
    private func springAnimation() -> CAAnimationGroup {
        let expand = strokeAnimation(key: .strokeEnd)
        expand.beginTime = 0

        let contract = strokeAnimation(key: .strokeStart)
        contract.beginTime = expand.duration

        let animation = CAAnimationGroup()
        animation.animations = [expand, contract]
        animation.duration = expand.duration + contract.duration
        animation.repeatCount = HUGE
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        return animation
    }

    private func strokeAnimation(key: CAPropertyAnimation.Key) -> CAPropertyAnimation {
        let animation = CAKeyframeAnimation(key: key)
        animation.duration = strokeDuration
        animation.keyTimes = [0, 0.3, 0.5, 0.7, 1]
        animation.values = [0, 0.1, 0.5, 0.9, 1]
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        return animation
    }

    // MARK: for Color
    private func colorAnimation(for process: AnimationProcess) -> CAPropertyAnimation {
        let animation = CAKeyframeAnimation(key: .strokeColor)
        animation.duration = rotationDuration * CFTimeInterval(lineColors.count)
        animation.repeatCount = HUGE
        animation.keyTimes = colorAnimationKeyTimes()
        animation.values = colorAnimationValues(for: process)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }

    private func colorAnimationKeyTimes() -> [NSNumber] {
        let c = Float(lineColors.count)
        return stride(from: 1, through: c, by: 1).reduce([]) { (r: [NSNumber], f: Float) in
            r + [NSNumber(value: f/c-1/c), NSNumber(value: f/c)]
        }
    }

    private func colorAnimationValues(for process: AnimationProcess) -> [CGColor] {
        var colors = ArraySlice(lineColors)
        var first: UIColor?

        if process == .skip {
            first = colors.first
            colors = colors.dropFirst()
        }

        var cgColors = colors.reduce([]) { (r: [CGColor], c: UIColor) in
            r + [c.cgColor, c.cgColor]
        }

        if let first = first {
            cgColors.append(contentsOf: [first.cgColor, first.cgColor])
        }

        return cgColors
    }
}

// MARK: - Stroke
extension SpringIndicatorView {
    /// between 0.0 and 1.0.
    public func strokeRatio(_ ratio: CGFloat) {
        if ratio <= 0 {
            pathLayer = nil
        } else if ratio >= 1 {
            strokeValue(1)
        } else {
            strokeValue(ratio)
        }
    }

    private func strokeValue(_ value: CGFloat) {
        if pathLayer == nil {
            pathLayer = makeRotationLayer()
            pathLayer?.path = makeRotationPath(for: .begin).cgPath
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        pathLayer?.strokeStart = 0
        pathLayer?.strokeEnd = value
        CATransaction.commit()
    }
}

// MARK: - RefreshIndicator extension
extension RefreshIndicator {
    func startIndicatorAnimation() {
        indicator.start(for: .during)
    }

    func stopIndicatorAnimation() {
        indicator.stopAnimation()
    }
}

open class RefreshIndicator: UIControl {
    deinit {
        stopIndicatorAnimation()
    }

    private let defaultContentHeight: CGFloat = 60
    private var refreshContext = UInt8()
    private var initialInsetTop: CGFloat = 0
    private weak var target: AnyObject?
    private var targetView: UIScrollView? {
        willSet {
            removeObserver()
        }
        didSet {
            addObserver()
        }
    }

    public let indicator = SpringIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    public private(set) var isRefreshing: Bool = false

    public convenience init() {
        self.init(frame: CGRect.zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupIndicator()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupIndicator()
    }

    private func setupIndicator() {
        indicator.lineWidth = 2
        indicator.rotationDuration = 1
        indicator.center = center
        indicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        addSubview(indicator)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false

        if let scrollView = superview as? UIScrollView {
            autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            frame.size.height = defaultContentHeight
            frame.size.width = scrollView.bounds.width
            center.x = scrollView.center.x
        }

        if let scrollView = targetView {
            initialInsetTop = scrollView.contentInset.top
        }
    }

    open override func willMove(toSuperview newSuperview: UIView!) {
        super.willMove(toSuperview: newSuperview)

        targetView = newSuperview as? UIScrollView
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()

        layoutIfNeeded()
    }

    open override func removeFromSuperview() {
        if targetView == superview {
            targetView = nil
        }
        super.removeFromSuperview()
    }

    open override func addTarget(_ target: Any?, action: Selector, for controlEvent: UIControl.Event) {
        super.addTarget(target, action: action, for: controlEvent)
        self.target = target as AnyObject?
    }

    open override func removeTarget(_ target: Any?, action: Selector?, for controlEvent: UIControl.Event) {
        super.removeTarget(target, action: action, for: controlEvent)

        self.target = nil
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) { // swiftlint:disable:this block_based_kvo
        guard let scrollView = object as? UIScrollView, context == &refreshContext else {
            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }

        if target == nil {
            targetView = nil
            return
        }

        if bounds.height <= 0 {
            return
        }

        if superview == scrollView {
            frame.origin.y = scrollOffset(scrollView)
        }

        if indicator.isSpinning {
            return
        }

        if isRefreshing && scrollView.isDragging == false {
            beginRefreshing(with: scrollView)
            return
        }

        let ratio = scrollRatio(scrollView)
        isRefreshing = ratio >= 1
        indicator.strokeRatio(ratio)
        rotationRatio(ratio)
    }

    private func addObserver() {
        targetView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: &refreshContext)
    }

    private func removeObserver() {
        targetView?.removeObserver(self, forKeyPath: "contentOffset", context: &refreshContext)
    }

    private func withoutObserve(_ block: (() -> Void)) {
        removeObserver()
        block()
        addObserver()
    }

    private func scrollOffset(_ scrollView: UIScrollView) -> CGFloat {
        var offsetY = scrollView.contentOffset.y
        if #available(iOS 11.0, *) {
            offsetY += initialInsetTop + scrollView.safeAreaInsets.top
        } else {
            offsetY += initialInsetTop
        }

        return offsetY
    }

    private func scrollRatio(_ scrollView: UIScrollView) -> CGFloat {
        var offsetY = scrollOffset(scrollView)

        offsetY += frame.size.height - indicator.frame.size.height
        if offsetY > 0 {
            offsetY = 0
        }

        return abs(offsetY / bounds.height)
    }

    private func rotationRatio(_ ratio: CGFloat) {
        let value = max(min(ratio, 1), 0)

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        indicator.indicatorView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi - Double.pi_4) * value, 0, 0, 1)
        CATransaction.commit()
    }
}

// MARK: - Refresh
extension RefreshIndicator {
    // MARK: begin
    private func beginRefreshing(with scrollView: UIScrollView) {
        sendActions(for: .valueChanged)
        indicator.layer.add(beginAnimation(), for: .scale)
        startIndicatorAnimation()

        let insetTop = initialInsetTop + bounds.height

        withoutObserve {
            scrollView.contentInset.top = insetTop
        }

        scrollView.contentOffset.y -= insetTop - initialInsetTop
    }

    // MARK: end
    /// Must be explicitly called when the refreshing has completed
    public func endRefreshing() {
        isRefreshing = false

        guard let scrollView = targetView else {
            stopIndicatorAnimation()
            return
        }

        let insetTop: CGFloat
        let safeAreaTop: CGFloat
        if #available(iOS 11.0, *) {
            safeAreaTop = scrollView.safeAreaInsets.top
        } else {
            safeAreaTop = 0
        }

        if scrollView.superview?.superview == nil {
            insetTop = 0
        } else {
            insetTop = initialInsetTop + safeAreaTop
        }

        if scrollView.contentInset.top + safeAreaTop > insetTop {
            let cachedOffsetY = scrollView.contentOffset.y
            scrollView.contentInset.top = insetTop - safeAreaTop

            if cachedOffsetY < -insetTop {
                indicator.layer.add(endAnimation(), for: .scale)
                scrollView.contentOffset.y = cachedOffsetY

                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                    scrollView.contentOffset.y = -insetTop
                }, completion: { _ in
                    self.stopIndicatorAnimation()
                })
            } else {
                CATransaction.begin()
                CATransaction.setCompletionBlock(stopIndicatorAnimation)
                indicator.layer.add(endAnimation(), for: .scale)
                CATransaction.commit()
            }
        } else {
            stopIndicatorAnimation()
        }
    }
}

// MARK: - Animation
extension RefreshIndicator {
    // MARK: for Begin
    private func beginAnimation() -> CAPropertyAnimation {
        let anim = CABasicAnimation(key: .scale)
        anim.duration = 0.1
        anim.repeatCount = 1
        anim.autoreverses = true
        anim.fromValue = 1
        anim.toValue = 1.3
        anim.timingFunction = CAMediaTimingFunction(name: .easeIn)

        return anim
    }

    // MARK: for End
    private func endAnimation() -> CAPropertyAnimation {
        let anim = CABasicAnimation(key: .scale)
        anim.duration = 0.3
        anim.repeatCount = 1
        anim.fromValue = 1
        anim.toValue = 0
        anim.timingFunction = CAMediaTimingFunction(name: .easeIn)
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false

        return anim
    }
}
