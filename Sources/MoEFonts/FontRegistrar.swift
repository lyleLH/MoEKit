import UIKit
import CoreText
import CoreGraphics

/// A generic utility for registering custom font files with Core Text.
public final class FontRegistrar {

    private init() {}

    /// Register all `.otf` and `.ttf` fonts found in the given bundle.
    /// - Parameter bundle: The bundle to search for font files. Defaults to `.main`.
    public static func registerFonts(from bundle: Bundle = .main) {
        let extensions = ["otf", "ttf"]
        for fileExtension in extensions {
            guard let urls = bundle.urls(forResourcesWithExtension: fileExtension, subdirectory: nil) else {
                continue
            }

            for url in urls {
                _ = registerFont(at: url)
            }
        }
    }

    /// Register a single font file at the given URL.
    /// - Parameter url: The file URL pointing to an `.otf` or `.ttf` font.
    /// - Returns: `true` if the font was successfully registered, `false` otherwise.
    @discardableResult
    public static func registerFont(at url: URL) -> Bool {
        guard let dataProvider = CGDataProvider(url: url as CFURL) else {
            return false
        }
        guard let font = CGFont(dataProvider) else {
            return false
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        if !success, let cfError = error?.takeUnretainedValue() {
            let nsError = cfError as Error
            // Font already registered is not a true failure
            if (nsError as NSError).code == CTFontManagerError.alreadyRegistered.rawValue {
                return true
            }
            return false
        }
        return success
    }
}
