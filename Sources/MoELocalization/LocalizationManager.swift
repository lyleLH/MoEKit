import Foundation

@preconcurrency public final class LocalizationManager {
    public static let _shared = LocalizationManager()

    @MainActor public static var shared: LocalizationManager {
        return _shared
    }

    private let lock = NSLock()
    private var _bundle: Bundle?
    private var bundle: Bundle? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _bundle
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _bundle = newValue
        }
    }

    private let defaultLanguage = "en"

    private init() {
        if UserDefaults.standard.object(forKey: "AppleLanguages") == nil {
            UserDefaults.standard.set([defaultLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }

        if let languages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String],
           let currentLanguage = languages.first {
            setupLocalizationBundleSync(for: currentLanguage)
        } else {
            setupLocalizationBundleSync(for: defaultLanguage)
        }
    }

    @MainActor public func localizedString(_ key: String, comment: String = "") -> String {
        return bundle?.localizedString(forKey: key, value: nil, table: nil)
            ?? Bundle.main.localizedString(forKey: key, value: nil, table: nil)
    }

    public nonisolated func localizedStringSync(_ key: String, comment: String = "") -> String {
        if let currentBundle = bundle {
            return currentBundle.localizedString(forKey: key, value: nil, table: nil)
        }
        return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
    }

    @MainActor public func setLanguage(_ language: String) {
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        setupLocalizationBundleSync(for: language)

        Task { @MainActor in
            NotificationCenter.default.post(name: Notification.Name("languageDidChange"), object: nil)
        }
    }

    public nonisolated func getCurrentLanguage() -> String {
        if let languages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String],
           let currentLanguage = languages.first {
            return currentLanguage
        }
        return defaultLanguage
    }

    private func setupLocalizationBundleSync(for language: String) {
        guard let languageBundlePath = Bundle.main.path(forResource: language, ofType: "lproj"),
              let languageBundle = Bundle(path: languageBundlePath) else {
            bundle = nil
            return
        }
        bundle = languageBundle
    }

    public nonisolated func getSupportedLanguages() -> [(code: String, name: String)] {
        let languages = Bundle.main.localizations.filter { $0 != "Base" }
        return languages.map { code in
            let locale = Locale(identifier: code)
            let name = locale.localizedString(forLanguageCode: code) ?? code
            return (code, name)
        }
    }
}

// MARK: - Convenience Extension
public extension String {
    var localized: String {
        return LocalizationManager._shared.localizedStringSync(self)
    }

    func localizedAsync() async -> String {
        await MainActor.run {
            LocalizationManager.shared.localizedString(self)
        }
    }
}
