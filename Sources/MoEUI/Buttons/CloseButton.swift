//
//  CloseButton.swift
//  MoEUI
//

import UIKit

open class CloseButton: DefaultButton {

    override open func commonInit() {
        super.commonInit()
        let config = UIImage.SymbolConfiguration(
            pointSize: 14,
            weight: .medium,
            scale: .medium
        )
        setImage(
            UIImage(systemName: "xmark", withConfiguration: config)?.withTintColor(.lightGray),
            for: .normal
        )
    }

    open func updateIconColor(color: UIColor) {
        let config = UIImage.SymbolConfiguration(
            pointSize: 14,
            weight: .medium,
            scale: .medium
        )
        setImage(
            UIImage(systemName: "xmark", withConfiguration: config)?.withTintColor(color),
            for: .normal
        )
    }
}
