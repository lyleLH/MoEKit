import UIKit

public extension UIViewController {

    @MainActor
    func smartDismiss(_ animate: Bool = true, completion: (() -> Void)? = nil) {
        if navigationController == nil {
            dismiss(animated: animate, completion: completion)
        } else {
            var currentVC: UIViewController? = self
            while currentVC != nil {
                if navigationController?.viewControllers[0] == currentVC {
                    dismiss(animated: animate, completion: completion)
                    break
                }
                currentVC = currentVC?.parent
            }
            _ = navigationController?.popViewController(animated: animate)
            completion?()
        }
    }
}
