import UIKit

public extension UIFont {

    /// Returns a bold variant of this font.
    var bold: UIFont {
        return with(.traitBold)
    }

    /// Returns an italic variant of this font.
    var italic: UIFont {
        return with(.traitItalic)
    }

    /// Returns a bold-italic variant of this font.
    var boldItalic: UIFont {
        return with(.traitBold, .traitItalic)
    }

    /// Returns a new font with the specified symbolic traits added.
    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let combined = UIFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits)
        guard let descriptor = fontDescriptor.withSymbolicTraits(combined) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    /// Returns a new font with the specified symbolic traits removed.
    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let remaining = fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))
        guard let descriptor = fontDescriptor.withSymbolicTraits(remaining) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
