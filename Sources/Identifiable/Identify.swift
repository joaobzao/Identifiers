//
//  Identify.swift
//  
//
//  Created by Joao Zao on 11/06/2020.
//

import UIKit

@propertyWrapper
public struct Identify<T: UIView> {

    public let identifier: String

    public var wrappedValue: T

    public init(wrappedValue: T, identifier: String) {
        self.wrappedValue = wrappedValue
        self.identifier = identifier

        setAccessibilityIdentifier()
    }

    func setAccessibilityIdentifier() {
        wrappedValue.accessibilityIdentifier = identifier
    }
}
