//
//  DefaultButton.swift
//  MoEUI
//

import UIKit

open class DefaultButton: UIButton {

    open func commonInit() {
        // to be overridden by subclass
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
