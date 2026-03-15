import UIKit

/// A protocol that defines a configurable font theme for an application.
///
/// Conform to this protocol to provide a custom set of fonts (e.g., a branded
/// typeface). The default implementation, ``SystemFontTheme``, uses the
/// platform system font.
public protocol FontTheme {
    /// Returns a font for the given size and weight.
    func font(size: CGFloat, weight: UIFont.Weight) -> UIFont

    /// A font suitable for titles (e.g., 24pt bold).
    var titleFont: UIFont { get }

    /// A font suitable for subtitles (e.g., 16pt medium).
    var subtitleFont: UIFont { get }

    /// A font suitable for body text (e.g., 14pt regular).
    var bodyFont: UIFont { get }

    /// A font suitable for captions (e.g., 12pt regular).
    var captionFont: UIFont { get }
}

/// A ``FontTheme`` that uses the platform system font.
public struct SystemFontTheme: FontTheme {

    public init() {}

    public func font(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: size, weight: weight)
    }

    public var titleFont: UIFont {
        return font(size: 24, weight: .bold)
    }

    public var subtitleFont: UIFont {
        return font(size: 16, weight: .medium)
    }

    public var bodyFont: UIFont {
        return font(size: 14, weight: .regular)
    }

    public var captionFont: UIFont {
        return font(size: 12, weight: .regular)
    }
}
