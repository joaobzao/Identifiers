import XCTest
@testable import Identifiable

final class IdentifiableTests: XCTestCase, Identifiable {
    @Identify(identifier: "Batatas")
    var label = UILabel()
    let button = UIButton()
    let textView = UITextView()
    let imageView = UIImageView()

    func testPropertyWrapperIdentifiers() {
        // Given

        let container = UIView()

        // When

        container.addSubview(label)
        container.addSubview(button)
        container.addSubview(textView)
        container.addSubview(imageView)

        generateAccessibilityIdentifiers()

        // Then

        XCTAssertEqual(container.subviews.count, 4)

        XCTAssertEqual(label.accessibilityIdentifier, "Batatas")
        XCTAssertEqual(button.accessibilityIdentifier, "IdentifiableTests.button")
        XCTAssertEqual(textView.accessibilityIdentifier, "IdentifiableTests.textView")
        XCTAssertEqual(imageView.accessibilityIdentifier, "IdentifiableTests.imageView")
    }
}
