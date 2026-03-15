import Foundation
import SwiftyJSON
import Alamofire

public struct EndpointError {
    public static let noResultError = LocalError(title: "No Result Error", description: "Request has not been fired.")
    public static let noNetworkError = LocalError(title: "Network Not Available", description: "Please retry after making sure that your network is available.")
    public static let unauthorizedError = LocalError(title: "Invalid Credential", description: "Please sign in again.")
    public static let serviceUnavailable = LocalError(title: "Service Unavailable", description: "We have issue connecting to the server.")
    public static let notFoundError = LocalError(title: "Not found Error", description: "A 404 error from the server.")
    public static let serverUnexpectedError = LocalError(title: "Service Unavailable", description: "We have issue connecting to the server.")
}

public enum EndpointResult<Response> {
    case success(Response)
    case failed(LocalError?)
}

public protocol Endpoint: AnyObject {
    associatedtype Response

    var result: EndpointResult<Self.Response> { get set }
    var path: String { get }
    var method: HTTPMethod { get }
    var param: [String: Any] { get }
    var shouldAuthenticate: Bool { get }

    func parseResult(statusCode: Int, json: JSON)
}

public protocol UploadEndpoint: Endpoint {
    associatedtype Response

    var fileNames: [String] { get }
    var mimeTypes: [String] { get }
    var data: [Data] { get }
}

public extension UploadEndpoint {
    var method: HTTPMethod { .post }
    var shouldAuthenticate: Bool { true }
}
