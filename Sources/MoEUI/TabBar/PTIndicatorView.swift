//
//  PTIndicatorView.swift
//  MoEUI
//

import UIKit

open class PTIndicatorView: UIView {
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }

    override open func tintColorDidChange() {
        super.tintColorDidChange()
        self.backgroundColor = tintColor
    }
}
