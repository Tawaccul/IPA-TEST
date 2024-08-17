import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "LaunchImage" asset catalog image resource.
    static let launch = ImageResource(name: "LaunchImage", bundle: resourceBundle)

    /// The "Logo (1)" asset catalog image resource.
    static let logo1 = ImageResource(name: "Logo (1)", bundle: resourceBundle)

    /// The "Logo (2)" asset catalog image resource.
    static let logo2 = ImageResource(name: "Logo (2)", bundle: resourceBundle)

    /// The "Logo (3)" asset catalog image resource.
    static let logo3 = ImageResource(name: "Logo (3)", bundle: resourceBundle)

    /// The "Logo (4)" asset catalog image resource.
    static let logo4 = ImageResource(name: "Logo (4)", bundle: resourceBundle)

    /// The "Logo (5)" asset catalog image resource.
    static let logo5 = ImageResource(name: "Logo (5)", bundle: resourceBundle)

    /// The "Logo (6)" asset catalog image resource.
    static let logo6 = ImageResource(name: "Logo (6)", bundle: resourceBundle)

    /// The "Logo (7)" asset catalog image resource.
    static let logo7 = ImageResource(name: "Logo (7)", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "LaunchImage" asset catalog image.
    static var launch: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launch)
#else
        .init()
#endif
    }

    /// The "Logo (1)" asset catalog image.
    static var logo1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo1)
#else
        .init()
#endif
    }

    /// The "Logo (2)" asset catalog image.
    static var logo2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo2)
#else
        .init()
#endif
    }

    /// The "Logo (3)" asset catalog image.
    static var logo3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo3)
#else
        .init()
#endif
    }

    /// The "Logo (4)" asset catalog image.
    static var logo4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo4)
#else
        .init()
#endif
    }

    /// The "Logo (5)" asset catalog image.
    static var logo5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo5)
#else
        .init()
#endif
    }

    /// The "Logo (6)" asset catalog image.
    static var logo6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo6)
#else
        .init()
#endif
    }

    /// The "Logo (7)" asset catalog image.
    static var logo7: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo7)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "LaunchImage" asset catalog image.
    static var launch: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launch)
#else
        .init()
#endif
    }

    /// The "Logo (1)" asset catalog image.
    static var logo1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo1)
#else
        .init()
#endif
    }

    /// The "Logo (2)" asset catalog image.
    static var logo2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo2)
#else
        .init()
#endif
    }

    /// The "Logo (3)" asset catalog image.
    static var logo3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo3)
#else
        .init()
#endif
    }

    /// The "Logo (4)" asset catalog image.
    static var logo4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo4)
#else
        .init()
#endif
    }

    /// The "Logo (5)" asset catalog image.
    static var logo5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo5)
#else
        .init()
#endif
    }

    /// The "Logo (6)" asset catalog image.
    static var logo6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo6)
#else
        .init()
#endif
    }

    /// The "Logo (7)" asset catalog image.
    static var logo7: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo7)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog color resource name.
    fileprivate let name: Swift.String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog image resource name.
    fileprivate let name: Swift.String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif