//
//  WhiteBlurView.swift
//  MoEUI
//

import UIKit
import VisualEffectView

public class WhiteBlurView: UIView {

    public var blurEffectView: VisualEffectView = VisualEffectView(frame: .zero)

    override public init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInit()
        backgroundColor = .clear
    }

    open func didInit() {
        addSubview(blurEffectView)
        blurEffectView.blurRadius = 10
        blurEffectView.scale = 1
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = bounds
    }
}
