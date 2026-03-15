import UIKit

public extension UIViewController {

    func embedViewController(containerView: UIView,
                             controller: UIViewController,
                             previous: UIViewController?,
                             withConstriant: Bool = true) {

        if let previous = previous {
            previous.willMove(toParent: nil)
            previous.view.removeFromSuperview()
            previous.removeFromParent()
        }

        addChild(controller)
        if withConstriant {
            controller.view.translatesAutoresizingMaskIntoConstraints = false
        }
        containerView.addSubview(controller.view)

        if withConstriant {
            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
        controller.didMove(toParent: self)
    }
}

public extension UIView {

    func embedView(view: UIView, withConstriant: Bool = true) {
        let containerView: UIView = self
        view.removeFromSuperview()

        if withConstriant {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        containerView.addSubview(view)

        if withConstriant {
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                view.topAnchor.constraint(equalTo: containerView.topAnchor),
                view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
    }
}
