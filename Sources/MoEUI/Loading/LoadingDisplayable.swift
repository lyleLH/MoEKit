//
//  LoadingDisplayable.swift
//  MoEUI
//

import UIKit

public protocol LoadingDisplayable {
    @MainActor var loadingView: LoadingView { get }

    @MainActor func showLoader()
    @MainActor func hideLoader()
}

public extension LoadingDisplayable {

    @MainActor func showLoader() {
        loadingView.startAnimating()
    }

    @MainActor func hideLoader() {
        loadingView.stopAnimating()
    }
}

public extension LoadingDisplayable where Self: UIViewController {

    @MainActor func setupLoadingView() {
        self.view.addSubview(loadingView)

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
