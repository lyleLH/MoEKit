import Foundation

public protocol ApiRequestProtocol {
    static func endpoint<E: Endpoint>(endpoint: E, completion: @escaping (E) -> Void)
}

public final class APIRequest: ApiRequestProtocol {
    public static func endpoint<E: Endpoint>(endpoint: E, completion: @escaping (E) -> Void) {
        // Base implementation — override in app
    }
}
