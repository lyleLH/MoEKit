# MoEKit

Reusable iOS toolkit — modular SPM package with 6 independent targets.

```
.package(url: "https://github.com/lyleLH/MoEKit.git", from: "1.0.0")
```

Import only what you need:

```swift
import MoEExtensions   // UIKit extensions, zero dependencies
import MoEUI           // UI components (tab bar, blur, buttons, base VCs)
import MoEFonts        // Font registration, Google Fonts, FontTheme
import MoEAnimations   // Particle effects
import MoELocalization // Runtime language switching
import MoENetworking   // Endpoint protocol, Alamofire/SwiftyJSON
```

---

## MoEExtensions

Zero external dependencies. Pure UIKit/Foundation extensions.

### UIImage

```swift
// Resize
let resized = image.resize(targetSize: CGSize(width: 100, height: 100))
let square = image.resize(to: 200) // proportional resize to width

// Crop
let cropped = image.crop(rect: CGRect(x: 10, y: 10, width: 100, height: 100))
let squared = image.cropImageToSquare()

// Transform
let rotated = image.rotate(radian: .pi / 4)
let fixed = image.fixRotationIfNecessaryImage()
let tinted = image.tinted(with: .red)
let padded = image.withInsets(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
let alpha50 = image.image(alpha: 0.5)

// Compose
let watermarked = image.addWaterMark(watermarkImage: logo, watermarkSize: CGSize(width: 50, height: 50))
let composite = UIImage.compositeTwoImages(top: overlay, bottom: background, newSize: size)
let overlaid = image.overlapWithImage(topImage: badge, at: CGPoint(x: 10, y: 10))

// Create
let solid = UIImage.image(color: .red, size: CGSize(width: 100, height: 100))
let circle = UIImage.drawCircle(diameter: 40, color: .blue)
let fromCI = UIImage.from(cimage: ciImage)

// Query
let hasAlpha = image.hasAlpha
```

### UIColor

```swift
// From hex
let color = UIColor(hex: "#FF5733")
let color2 = UIColor(hex: "FF5733")
let color3 = UIColor(rgb: 0xFF5733)
let color4 = UIColor(red: 255, green: 87, blue: 51)
let color5 = UIColor(string: "FF5733AA") // with alpha

// To hex
let hex = color.toHex()           // "FF5733"
let hexAlpha = color.toHex(alpha: true) // "FF5733FF"

// Manipulate
let saturated = color.withSaturation(0.5)
let alpha = color.alphaValue
let random = UIColor.random()
```

### UIView

```swift
// Auto Layout
view.pinToSuperView()                          // pin all edges
view.pinToSafeArea()                           // pin to safe area
view.centerInSuperView()                       // center X and Y
view.constraint(width: 100)                    // fixed width
view.constraint(height: 50)                    // fixed height
view.makeWidthEqualHeight()                    // 1:1 aspect ratio
view.prepareForAutoLayout()                    // translatesAutoresizingMask = false
parentView.embedView(view: childView)          // add subview pinned to all edges

// IBInspectable
view.cornerRadius = 12
view.borderWidth = 1
view.borderColor = .gray

// Utilities
let screenshot = view.screenshot()
let image = view.asImage(2.0)                  // render at 2x scale
view.shake()                                   // horizontal shake animation
view.roundCorners([.topLeft, .topRight], radius: 16)

// Color sampling
let color = view.colorOfPoint(point: CGPoint(x: 50, y: 50))
```

### UIViewController

```swift
// Embed child VC
embedViewController(containerView: containerView, controller: childVC, previous: oldVC)

// Smart dismiss (pops if in nav stack, dismisses if modal)
smartDismiss(true) { print("dismissed") }
```

### Other

```swift
// CGPoint distance
let dist = pointA.distance(to: pointB)

// CGRect from center
let rect = CGRect(center: CGPoint(x: 100, y: 100), size: CGSize(width: 50, height: 50))

// Date string formatting
let formatted = "2024-12-25T10:30:00Z".dateToString() // "25 Dec 10:30"
```

---

## MoEUI

Depends on: `MoEExtensions`, `VisualEffectView`

### PTCardTabBar

A floating card-style tab bar with blur background, animated indicator, and haptic feedback.

```swift
// Use via PTCardTabBarController (replaces UITabBarController)
class MyTabBarController: PTCardTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // System tab bar is automatically hidden
        // customTabBar is the floating card tab bar
    }
}

// Update icons dynamically
customTabBar.updateIcon(at: 0, image: newImage)

// Show/hide
setTabBarHidden(true, animated: true)
```

### DefaultBlurView / WhiteBlurView

```swift
let blur = DefaultBlurView()
blur.usingDarkEffect()   // dark tinted blur
blur.usingWhiteEffect()  // white tinted blur
blur.blurRadius = 15.0   // adjust blur intensity
```

### DefaultButton / CloseButton

```swift
// Base button with commonInit() hook
class MyButton: DefaultButton {
    override func commonInit() {
        // custom setup
    }
}

// Pre-configured close button (xmark icon)
let close = CloseButton()
close.updateIconColor(color: .white)
```

### LoadingDisplayable

```swift
class MyVC: UIViewController, LoadingDisplayable {
    let loadingView = LoadingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView() // adds centered loading indicator
    }

    func fetchData() {
        showLoader()
        // ... async work ...
        hideLoader()
    }
}
```

### Base View Controllers

```swift
// Configurable navigation bar appearance
class MyVC: DefaultViewController {
    override var navigationBarHidden: Bool { false }
    override var navigationBarIsTranslucent: Bool { true }
    override var navigationBarBackgroundColor: UIColor { .systemBackground }
    override var navigationBarTintColor: UIColor { .label }
}

// Also available:
// DefaultTableViewController, DefaultCollectionViewController, DefaultNavigationViewController
```

---

## MoEFonts

Zero external dependencies.

### FontRegistrar

```swift
// Register all .otf/.ttf fonts from main bundle
FontRegistrar.registerFonts()

// Register from a custom bundle
FontRegistrar.registerFonts(from: myBundle)

// Register a single font file
let success = FontRegistrar.registerFont(at: fontFileURL)
```

### FontTheme

```swift
// Define your app's font theme
struct AppFontTheme: FontTheme {
    func font(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .bold: return UIFont(name: "Poppins-Bold", size: size) ?? .systemFont(ofSize: size, weight: weight)
        default:    return UIFont(name: "Poppins-Regular", size: size) ?? .systemFont(ofSize: size, weight: weight)
        }
    }
    var titleFont: UIFont    { font(size: 24, weight: .bold) }
    var subtitleFont: UIFont { font(size: 16, weight: .medium) }
    var bodyFont: UIFont     { font(size: 14, weight: .regular) }
    var captionFont: UIFont  { font(size: 12, weight: .regular) }
}

// Use system fonts as default
let theme: FontTheme = SystemFontTheme()
label.font = theme.titleFont
```

### GoogleFontManager

```swift
// Configure with API key (call once at app launch)
GoogleFontManager.shared.configure(apiKey: "YOUR_API_KEY")

// Search fonts
let fonts = try await GoogleFontManager.shared.searchFonts(query: "Roboto")

// Download a font
try await GoogleFontManager.shared.downloadFont(font: fonts[0])

// Check status
let isDownloaded = GoogleFontManager.shared.isFontDownloaded("Roboto")
let downloaded = GoogleFontManager.shared.getDownloadedFonts() // ["Roboto", "Montserrat"]

// Delete a font
try await GoogleFontManager.shared.deleteFont(font: fonts[0])

// Listen for deletions
NotificationCenter.default.addObserver(forName: GoogleFontManager.fontDeletedNotification, ...)
```

### UIFont+Traits

```swift
let boldFont = font.bold
let italicFont = font.italic
let boldItalic = font.boldItalic
let custom = font.with(.traitBold, .traitItalic)
let plain = font.without(.traitBold)
```

---

## MoEAnimations

Zero external dependencies.

### Comet

Particle comet effect using CAEmitterLayer.

```swift
let comet = Comet(
    startPoint: CGPoint(x: 0, y: 0),
    endPoint: CGPoint(x: view.bounds.width, y: view.bounds.height),
    lineColor: UIColor.white.withAlphaComponent(0.2),
    cometColor: .white
)

// Add trail line
view.layer.addSublayer(comet.drawLine())

// Add animated particles
view.layer.addSublayer(comet.animate())
```

---

## MoELocalization

Zero external dependencies.

### LocalizationManager

Thread-safe runtime language switching.

```swift
// Get localized string
let title = "home.title".localized

// Switch language at runtime
LocalizationManager.shared.setLanguage("zh-Hans")

// Get current language
let lang = LocalizationManager.shared.getCurrentLanguage() // "en"

// List supported languages
let languages = LocalizationManager.shared.getSupportedLanguages()
// [("en", "English"), ("zh-Hans", "简体中文")]

// Listen for language changes
NotificationCenter.default.addObserver(forName: Notification.Name("languageDidChange"), ...)
```

---

## MoENetworking

Depends on: `Alamofire`, `SwiftyJSON`

### Endpoint

```swift
class FetchUserEndpoint: Endpoint {
    struct Response {
        var name: String
        var email: String
    }

    var result: EndpointResult<Response> = .failed(EndpointError.noResultError)
    var path: String { "users/me" }
    var method: HTTPMethod { .get }
    var param: [String: Any] { [:] }
    var shouldAuthenticate: Bool { true }

    func parseResult(statusCode: Int, json: JSON) {
        if let name = json["name"].string, let email = json["email"].string {
            result = .success(Response(name: name, email: email))
        } else {
            result = .failed(LocalError(title: "Parse Error"))
        }
    }
}
```

### LocalError

```swift
let error = LocalError(title: "Network Error", description: "No internet connection")
print(error.message) // "No internet connection"

// Predefined errors
EndpointError.noNetworkError
EndpointError.unauthorizedError
EndpointError.serviceUnavailable
```

---

## Requirements

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+
