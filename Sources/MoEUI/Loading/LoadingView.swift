//
//  LoadingView.swift
//  MoEUI
//

import UIKit

public final class LoadingView: UIActivityIndicatorView {

    public init() {
        super.init(frame: .zero)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        color = .white
        hidesWhenStopped = true
    }
}
