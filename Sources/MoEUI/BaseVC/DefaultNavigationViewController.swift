//
//  DefaultNavigationViewController.swift
//  MoEUI
//

import UIKit
import MoEExtensions

public extension DefaultNavigationViewController {
    func applyDefaultNaviAppearance() {
        naviBarSetting()
    }
}

open class DefaultNavigationViewController: UINavigationController, UINavigationControllerDelegate {

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        visibleViewController?.preferredStatusBarStyle ?? .default
    }

    public var bgColor: UIColor = .white
    public var isTranslucent = false

    public var popViewController: UIViewController?

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        naviBarSetting()
    }

    private func naviBarSetting() {
        for controlState in [UIControl.State.normal, UIControl.State.highlighted, UIControl.State.disabled] {
            UIBarButtonItem.appearance().setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline) as Any],
                for: controlState
            )
        }

        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = bgColor
        navigationBar.isTranslucent = isTranslucent
        navigationBar.backItem?.backButtonDisplayMode = .minimal
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline) as Any
        ]

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
        let backImage = UIImage(systemName: "chevron.backward", withConfiguration: symbolConfig)?
            .withInsets(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
    }

    open func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        popViewController = viewController
    }

    open func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let presentationController = presentationController,
           let presentationControllerDelegate = presentationController.delegate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                presentationControllerDelegate.presentationControllerDidDismiss?(presentationController)
            }
        }
    }

    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
}
