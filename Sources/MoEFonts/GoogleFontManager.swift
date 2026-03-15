import Foundation
import CoreText
import CoreGraphics
import UIKit

/// Manages downloading, registering, caching, and deleting Google Fonts.
///
/// Before using any API-dependent method, call ``configure(apiKey:)`` to
/// supply your Google Fonts API key.
@MainActor
public final class GoogleFontManager {

    public static let shared = GoogleFontManager()

    private let baseURL = "https://www.googleapis.com/webfonts/v1/webfonts"
    private let downloadedFontsKey = "com.moefonts.downloadedFonts"
    private let fontsCacheKey = "com.moefonts.googleFontsCache"
    private let cacheDuration: TimeInterval = 2 * 24 * 60 * 60 // 2 days

    private var apiKey: String?
    private var downloadedFontRecords: [String: FontMetadata] = [:]

    // MARK: - Public Types

    /// Metadata stored for each downloaded font family.
    public struct FontMetadata: Codable, Sendable {
        public let category: String
        public let variants: [String]
        public let subsets: [String]
        public let version: String
        public let downloadDate: Date

        public init(category: String, variants: [String], subsets: [String], version: String, downloadDate: Date) {
            self.category = category
            self.variants = variants
            self.subsets = subsets
            self.version = version
            self.downloadDate = downloadDate
        }
    }

    /// A timestamped cache of Google Font entries.
    public struct FontsCache: Codable, Sendable {
        public let fonts: [GoogleFont]
        public let timestamp: Date

        public init(fonts: [GoogleFont], timestamp: Date) {
            self.fonts = fonts
            self.timestamp = timestamp
        }
    }

    /// Errors that can occur during font operations.
    public enum FontError: LocalizedError, Sendable {
        case fontNotFound
        case unregisterFailed
        case downloadFailed
        case invalidFontData
        case fontRegistrationFailed
        case apiKeyNotConfigured

        public var errorDescription: String? {
            switch self {
            case .fontNotFound:
                return "Font not found"
            case .unregisterFailed:
                return "Failed to unregister font"
            case .downloadFailed:
                return "Failed to download font"
            case .invalidFontData:
                return "Invalid font data"
            case .fontRegistrationFailed:
                return "Failed to register font"
            case .apiKeyNotConfigured:
                return "Google Fonts API key has not been configured"
            }
        }
    }

    // MARK: - Notification Names

    /// Posted when a font is deleted. `userInfo` contains `fontFamily` (String) and `variants` ([String]).
    public static let fontDeletedNotification = Notification.Name("com.moefonts.fontDeleted")

    // MARK: - Initialization

    private init() {
        loadDownloadedFontRecords()
        registerSavedFonts()
    }

    // MARK: - Configuration

    /// Set the Google Fonts API key. Must be called before ``searchFonts(query:)``.
    public func configure(apiKey: String) {
        self.apiKey = apiKey
    }

    // MARK: - Downloaded Font Queries

    /// Returns the family names of all downloaded fonts.
    public func getDownloadedFonts() -> [String] {
        return Array(downloadedFontRecords.keys)
    }

    /// Returns `true` if a font with the given family name has been downloaded.
    public func isFontDownloaded(_ fontFamily: String) -> Bool {
        return downloadedFontRecords.keys.contains(fontFamily)
    }

    /// Returns the stored metadata for a downloaded font family, or `nil`.
    public func getFontMetadata(_ fontFamily: String) -> FontMetadata? {
        return downloadedFontRecords[fontFamily]
    }

    // MARK: - Download

    /// Downloads and registers all non-italic variants of the given Google Font.
    public func downloadFont(font: GoogleFont) async throws {
        let variantURLs = font.variantFontURLs
        var registeredNames: [String] = []

        for (variant, url) in variantURLs {
            do {
                let postScriptName = try await downloadAndRegisterVariant(family: font.family, variant: variant, url: url)
                registeredNames.append(postScriptName)
            } catch {
                // Continue downloading remaining variants
                continue
            }
        }

        if registeredNames.isEmpty {
            throw FontError.fontRegistrationFailed
        }

        downloadedFontRecords[font.family] = FontMetadata(
            category: font.category,
            variants: registeredNames,
            subsets: font.subsets,
            version: font.version,
            downloadDate: Date()
        )
        saveDownloadedFontRecords()
    }

    // MARK: - Delete

    /// Unregisters and deletes all variants of the given font.
    public func deleteFont(font: GoogleFont) async throws {
        guard let metadata = downloadedFontRecords[font.family] else {
            return
        }

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        for postScriptName in metadata.variants {
            let fontURL = documentsPath.appendingPathComponent("\(postScriptName).ttf")
            if FileManager.default.fileExists(atPath: fontURL.path) {
                var error: Unmanaged<CFError>?
                CTFontManagerUnregisterFontsForURL(fontURL as CFURL, .process, &error)
                try? FileManager.default.removeItem(at: fontURL)
            }
        }

        downloadedFontRecords.removeValue(forKey: font.family)
        saveDownloadedFontRecords()

        NotificationCenter.default.post(
            name: GoogleFontManager.fontDeletedNotification,
            object: nil,
            userInfo: ["fontFamily": font.family, "variants": metadata.variants]
        )
    }

    // MARK: - Search

    /// Searches for fonts matching the query. Uses a local cache (valid for 2 days)
    /// before falling back to the Google Fonts API.
    public func searchFonts(query: String) async throws -> [GoogleFont] {
        guard let apiKey, !apiKey.isEmpty else {
            throw FontError.apiKeyNotConfigured
        }

        if let fonts = try loadFromCache() {
            return fonts.filter { font in
                query.isEmpty || font.family.lowercased().contains(query.lowercased())
            }
        }

        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "sort", value: "popularity")
        ]

        guard let url = components?.url else {
            throw FontError.downloadFailed
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(GoogleFontsResponse.self, from: data)

        try saveToCache(fonts: response.items)

        return response.items.filter { font in
            query.isEmpty || font.family.lowercased().contains(query.lowercased())
        }
    }

    // MARK: - Private Helpers

    private func downloadAndRegisterVariant(family: String, variant: String, url: String) async throws -> String {
        guard let downloadURL = URL(string: url) else {
            throw FontError.invalidFontData
        }

        let (localURL, _) = try await URLSession.shared.download(from: downloadURL)

        guard let dataProvider = CGDataProvider(url: localURL as CFURL),
              let cgFont = CGFont(dataProvider) else {
            throw FontError.invalidFontData
        }

        guard let postScriptName = cgFont.postScriptName as String? else {
            throw FontError.invalidFontData
        }

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent("\(postScriptName).ttf")

        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }
        try FileManager.default.moveItem(at: localURL, to: destinationURL)

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(destinationURL as CFURL, .process, &error) {
            try? FileManager.default.removeItem(at: destinationURL)
            throw FontError.fontRegistrationFailed
        }

        return postScriptName
    }

    private func loadDownloadedFontRecords() {
        if let data = UserDefaults.standard.data(forKey: downloadedFontsKey),
           let records = try? JSONDecoder().decode([String: FontMetadata].self, from: data) {
            downloadedFontRecords = records
        }
    }

    private func saveDownloadedFontRecords() {
        if let data = try? JSONEncoder().encode(downloadedFontRecords) {
            UserDefaults.standard.set(data, forKey: downloadedFontsKey)
        }
    }

    private func loadFromCache() throws -> [GoogleFont]? {
        guard let data = UserDefaults.standard.data(forKey: fontsCacheKey),
              let cache = try? JSONDecoder().decode(FontsCache.self, from: data) else {
            return nil
        }

        if Date().timeIntervalSince(cache.timestamp) > cacheDuration {
            return nil
        }

        return cache.fonts
    }

    private func saveToCache(fonts: [GoogleFont]) throws {
        let cache = FontsCache(fonts: fonts, timestamp: Date())
        if let data = try? JSONEncoder().encode(cache) {
            UserDefaults.standard.set(data, forKey: fontsCacheKey)
        }
    }

    private func registerSavedFonts() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        for (_, metadata) in downloadedFontRecords {
            for postScriptName in metadata.variants {
                let fontURL = documentsPath.appendingPathComponent("\(postScriptName).ttf")
                if FileManager.default.fileExists(atPath: fontURL.path) {
                    guard CGDataProvider(url: fontURL as CFURL) != nil,
                          CGFont(CGDataProvider(url: fontURL as CFURL)!) != nil else {
                        continue
                    }

                    var error: Unmanaged<CFError>?
                    CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
                }
            }
        }
    }
}
