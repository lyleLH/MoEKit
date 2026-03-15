//
//  DefaultViewController.swift
//  MoEUI
//

import UIKit

open class DefaultViewController: UIViewController {

    open var navigationBarHidden: Bool {
        return false
    }

    open var navigationBarIsTranslucent: Bool {
        return false
    }

    open var navigationBarBackgroundColor: UIColor {
        return .white
    }

    open var navigationBarTintColor: UIColor {
        return .black
    }

    open var navigationViewBackgroundColor: UIColor {
        return .white
    }

    open var isBackButtonHasBackground: Bool {
        return false
    }

    public var defaultNavigationController: DefaultNavigationViewController? {
        return navigationController as? DefaultNavigationViewController
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let parent = parent as? DefaultViewController {
            applyNavigationBarSettings(from: parent)
        } else if let parent = parent as? DefaultTableViewController {
            applyNavigationBarSettings(
                hidden: parent.navigationBarHidden,
                translucent: parent.navigationBarIsTranslucent,
                bgColor: parent.navigationBarBackgroundColor,
                tintColor: parent.navigationBarTintColor,
                viewBgColor: parent.navigationViewBackgroundColor
            )
        } else if let parent = parent as? DefaultCollectionViewController {
            applyNavigationBarSettings(
                hidden: parent.navigationBarHidden,
                translucent: parent.navigationBarIsTranslucent,
                bgColor: parent.navigationBarBackgroundColor,
                tintColor: parent.navigationBarTintColor,
                viewBgColor: parent.navigationViewBackgroundColor
            )
        } else {
            applyNavigationBarSettings(from: self)
        }

        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    private func applyNavigationBarSettings(from source: DefaultViewController) {
        applyNavigationBarSettings(
            hidden: source.navigationBarHidden,
            translucent: source.navigationBarIsTranslucent,
            bgColor: source.navigationBarBackgroundColor,
            tintColor: source.navigationBarTintColor,
            viewBgColor: source.navigationViewBackgroundColor
        )
    }

    private func applyNavigationBarSettings(
        hidden: Bool,
        translucent: Bool,
        bgColor: UIColor,
        tintColor: UIColor,
        viewBgColor: UIColor
    ) {
        navigationController?.navigationBar.isHidden = hidden
        navigationController?.navigationBar.isTranslucent = translucent
        navigationController?.navigationBar.backgroundColor = bgColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.titleTextAttributes?[.foregroundColor] = tintColor
        navigationController?.view.backgroundColor = viewBgColor
    }
}
