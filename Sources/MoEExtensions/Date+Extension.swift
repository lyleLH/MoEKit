import Foundation

public extension String {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let actualDate = dateFormatter.date(from: self) ?? .now
        dateFormatter.dateFormat = "dd MMM HH:mm"
        let dateString = dateFormatter.string(from: actualDate)
        return dateString
    }
}
