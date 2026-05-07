//
//  MockLoginValidator.swift
//  LoginDemoAppTests
//
//  Created by Jitendra Patil on 06/05/26.
//

import XCTest
@testable import LoginDemoApp

final class MockLoginValidator: LoginValidator {
    var stubbedResult: ValidationResult = .success
    var validateCallCount = 0
    var capturedUsername: String?
    var capturedPassword: String?

    func validate(username: String, password: String) -> ValidationResult {
        validateCallCount += 1
        capturedUsername = username
        capturedPassword = password
        return stubbedResult
    }
}
