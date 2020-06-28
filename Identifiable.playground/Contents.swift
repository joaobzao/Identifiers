import UIKit

@propertyWrapper
public struct Identify<T: UIView> {

    public let identifier: String
    public let wrappedValue: T

    public init(wrappedValue: T, identifier: String) {
        self.wrappedValue = wrappedValue
        self.identifier = identifier

        setAccessibilityIdentifier()
    }

    func setAccessibilityIdentifier() {
        wrappedValue.accessibilityIdentifier = identifier
    }
}

protocol Identifiable {
    func generateAccessibilityIdentifiers()
}

extension Identifiable {
    func generateAccessibilityIdentifiers() {
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach { child in
            if
                let view = child.value as? UIView,
                let identifier = child
                    .label?
                    .replacingOccurrences(of: ".storage", with: "")
                    .replacingOccurrences(of: "$__lazy_storage_$_", with: "") {
                view.accessibilityIdentifier = "\(type(of: self)).\(identifier)"
            }
        }
    }
}

extension UIView {
    func printIdenfiers() {
        self.subviews.forEach { print("\($0.accessibilityIdentifier ?? "🚧 404 - Accessibility Identifier not found for \($0)")") }
    }
}

class SampleView: Identifiable {

    @Identify(identifier: "Batatas")
    var label = UILabel()

    let container = UIView()
    let button = UIButton()

    init() {
        container.addSubview(label)
        container.addSubview(button)

        generateAccessibilityIdentifiers()

        container.printIdenfiers()
    }
}

SampleView()



