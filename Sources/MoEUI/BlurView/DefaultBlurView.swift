//
//  DefaultBlurView.swift
//  MoEUI
//

import UIKit
import VisualEffectView

public class DefaultBlurView: UIView {

    public let blurEffectView: VisualEffectView = VisualEffectView(frame: .zero)

    public var blurRadius: CGFloat = 10.0 {
        didSet {
            setNeedsLayout()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInit()
    }

    open func didInit() {
        addSubview(blurEffectView)
        backgroundColor = .clear
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        Task { @MainActor in
            usingDarkEffect()
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = bounds
        blurEffectView.blurRadius = blurRadius
    }

    @MainActor public func usingDarkEffect() {
        blurEffectView.colorTint = .darkGray
        blurEffectView.colorTintAlpha = 0.5
        blurEffectView.blurRadius = blurRadius
        blurEffectView.scale = 1
    }

    @MainActor public func usingWhiteEffect() {
        blurEffectView.colorTint = .white
        blurEffectView.colorTintAlpha = 0.25
        blurEffectView.blurRadius = blurRadius
        blurEffectView.scale = 1
    }
}
