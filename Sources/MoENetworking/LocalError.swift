import Foundation

public class LocalError: Error, Equatable, @unchecked Sendable {
    public static func == (lhs: LocalError, rhs: LocalError) -> Bool {
        return lhs.title == rhs.title && lhs.errorDescription == rhs.errorDescription
    }

    public var message: String {
        return errorDescription ?? "An unexpected error occurred: \(String(describing: self))"
    }

    public private(set) var title: String?
    public private(set) var errorDescription: String?

    public init(title: String? = "Unexpected Error", description: String? = nil) {
        self.title = title
        self.errorDescription = description
    }

    public static let unknown = LocalError(title: "Unknown error")
}
