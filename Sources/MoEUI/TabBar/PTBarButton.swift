//
//  PTBarButton.swift
//  MoEUI
//

import UIKit
import MoEExtensions

open class PTBarButton: UIButton {

    open var selectedColor: UIColor! = .black {
        didSet {
            reloadApperance()
        }
    }

    open var unselectedColor: UIColor! = UIColor(rgb: 0x9b9b9b) {
        didSet {
            reloadApperance()
        }
    }

    public init(forItem item: UITabBarItem) {
        super.init(frame: .zero)
        setImage(item.image, for: .normal)
    }

    public init(image: UIImage) {
        super.init(frame: .zero)
        setImage(image, for: .normal)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open var isSelected: Bool {
        didSet {
            reloadApperance()
        }
    }

    open func reloadApperance() {
        self.tintColor = isSelected ? selectedColor : unselectedColor
    }
}
