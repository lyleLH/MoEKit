//
//  DefaultCollectionViewController.swift
//  MoEUI
//

import UIKit

open class DefaultCollectionViewController: UICollectionViewController {

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

    public var defaultNavigationController: DefaultNavigationViewController? {
        return navigationController as? DefaultNavigationViewController
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftItemsSupplementBackButton = true
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let parent = parent as? DefaultViewController {
            applyNavigationBarSettings(
                hidden: parent.navigationBarHidden,
                translucent: parent.navigationBarIsTranslucent,
                bgColor: parent.navigationBarBackgroundColor,
                tintColor: parent.navigationBarTintColor,
                viewBgColor: parent.navigationViewBackgroundColor
            )
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
            applyNavigationBarSettings(
                hidden: navigationBarHidden,
                translucent: navigationBarIsTranslucent,
                bgColor: navigationBarBackgroundColor,
                tintColor: navigationBarTintColor,
                viewBgColor: navigationViewBackgroundColor
            )
        }

        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    open func safeReload(indexPath: IndexPath) {
        self.collectionView.reloadData()
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
