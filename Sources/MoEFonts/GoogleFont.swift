import Foundation

/// The top-level response returned by the Google Fonts API.
public struct GoogleFontsResponse: Codable, Sendable {
    public let items: [GoogleFont]
    public let kind: String

    public init(items: [GoogleFont], kind: String) {
        self.items = items
        self.kind = kind
    }
}

/// A single font family entry from the Google Fonts API.
public struct GoogleFont: Codable, Sendable {
    public let family: String
    public let files: [String: String]
    public let category: String
    public let kind: String
    public let version: String
    public let lastModified: String
    public let variants: [String]
    public let subsets: [String]

    public init(
        family: String,
        files: [String: String],
        category: String,
        kind: String,
        version: String,
        lastModified: String,
        variants: [String],
        subsets: [String]
    ) {
        self.family = family
        self.files = files
        self.category = category
        self.kind = kind
        self.version = version
        self.lastModified = lastModified
        self.variants = variants
        self.subsets = subsets
    }

    /// Returns non-italic variant URLs with HTTPS scheme enforced.
    public var variantFontURLs: [(variant: String, url: String)] {
        return variants.compactMap { variant -> (String, String)? in
            if variant.contains("italic") {
                return nil
            }
            if let url = files[variant]?.replacingOccurrences(of: "http://", with: "https://") {
                return (variant, url)
            }
            return nil
        }
    }

    /// Returns the URL for the regular variant, trying common fallback keys.
    public var regularFontURL: String? {
        let priorities = ["regular", "400", "normal"]
        for variant in priorities {
            if let url = files[variant]?.replacingOccurrences(of: "http://", with: "https://") {
                return url
            }
        }
        return nil
    }
}
