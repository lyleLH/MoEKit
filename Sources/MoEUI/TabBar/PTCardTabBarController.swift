//
//  PTCardTabBarController.swift
//  MoEUI
//

import UIKit

open class PTCardTabBarController: UITabBarController {

    @IBInspectable public var tintColor: UIColor? {
        didSet {
            customTabBar.tintColor = tintColor
            customTabBar.reloadApperance()
        }
    }

    @IBInspectable public var tabBarBackgroundColor: UIColor? {
        didSet {
            customTabBar.backgroundColor = tabBarBackgroundColor
            customTabBar.reloadApperance()
        }
    }

    public let customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()

    public private(set) lazy var smallBottomView: UIView = {
        let anotherSmallView = UIView()
        anotherSmallView.backgroundColor = .clear
        anotherSmallView.translatesAutoresizingMaskIntoConstraints = false
        return anotherSmallView
    }()

    override open var selectedIndex: Int {
        didSet {
            customTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }

    override open var selectedViewController: UIViewController? {
        didSet {
            customTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }

    fileprivate var bottomSpacing: CGFloat = 20
    fileprivate var tabBarHeight: CGFloat = 70
    fileprivate var horizontleSpacing: CGFloat = 20

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight + bottomSpacing, right: 0)

        self.tabBar.isHidden = true

        addAnotherSmallView()
        setupTabBar()

        if let items = tabBar.items {
            customTabBar.items = items
        } else {
            print("Warning: tabBar.items is nil in PTCardTabBarController")
        }
    }

    public override func setTabBarHidden(_ isHidden: Bool, animated: Bool) {
        let block = {
            self.customTabBar.alpha = isHidden ? 0 : 1
            self.additionalSafeAreaInsets = isHidden
                ? .zero
                : UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarHeight + self.bottomSpacing, right: 0)
        }

        if animated {
            UIView.animate(withDuration: 0.25, animations: block)
        } else {
            block()
        }
    }

    fileprivate func addAnotherSmallView() {
        self.view.addSubview(smallBottomView)

        smallBottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        let card: NSLayoutConstraint

        if #available(iOS 11.0, *) {
            card = smallBottomView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                        constant: tabBarHeight)
        } else {
            card = smallBottomView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor,
                                                        constant: tabBarHeight)
        }

        card.priority = .defaultHigh
        card.isActive = true

        smallBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        smallBottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    fileprivate func setupTabBar() {
        customTabBar.delegate = self
        self.view.addSubview(customTabBar)

        customTabBar.bottomAnchor.constraint(equalTo: smallBottomView.topAnchor, constant: 0).isActive = true
        customTabBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        customTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                              constant: horizontleSpacing).isActive = true
        customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true

        self.view.bringSubviewToFront(customTabBar)
        self.view.bringSubviewToFront(smallBottomView)

        customTabBar.tintColor = tintColor
    }

    override open var viewControllers: [UIViewController]? {
        didSet {
            if let items = tabBar.items {
                customTabBar.items = items
            }
        }
    }
}

extension PTCardTabBarController: @preconcurrency CardTabBarDelegate {
    public func cardTabBar(_ sender: PTCardTabBar, didSelectItemAt index: Int) {
        self.selectedIndex = index
    }
}
