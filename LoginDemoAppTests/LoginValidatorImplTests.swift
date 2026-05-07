//
//  LoginValidatorImplTests.swift
//  LoginDemoAppTests
//
//  Created by Jitendra Patil on 06/05/26.
//

import XCTest
@testable import LoginDemoApp

final class LoginValidatorImplTests: XCTestCase {

    var sut: LoginValidatorImpl!

    override func setUp() {
        super.setUp()
        sut = LoginValidatorImpl()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Username Validation

    func test_validate_emptyUsername_returnsFailure() {
        // Arrange
        let username = ""
        let password = "pass1"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .failure(let message) = result else {
            return XCTFail("Expected .failure but got .success")
        }
        XCTAssertEqual(message, "Username cannot be empty")
    }

    func test_validate_whitespaceOnlyUsername_returnsFailure() {
        // Arrange
        let username = "   "
        let password = "pass1"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .failure(let message) = result else {
            return XCTFail("Expected .failure but got .success")
        }
        XCTAssertEqual(message, "Username cannot be empty")
    }

    func test_validate_newlineOnlyUsername_returnsFailure() {
        // Arrange
        let username = "\n\t\n"
        let password = "pass1"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .failure(let message) = result else {
            return XCTFail("Expected .failure but got .success")
        }
        XCTAssertEqual(message, "Username cannot be empty")
    }

    func test_validate_usernameWithLeadingAndTrailingSpaces_returnsSuccess() {
        // Arrange — trimmed value is non-empty, so validation should pass
        let username = "  alice  "
        let password = "pass1"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .success = result else {
            if case .failure(let message) = result {
                return XCTFail("Expected .success but got .failure(\"\(message)\")")
            }
            return XCTFail("Expected .success")
        }
    }

    func test_validate_validUsername_doesNotReturnUsernameError() {
        // Arrange
        let username = "alice"
        let password = "pass1"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert — any failure here must NOT be about the username
        if case .failure(let message) = result {
            XCTAssertNotEqual(message, "Username cannot be empty")
        }
    }

    // MARK: - Password Validation

    func test_validate_emptyPassword_returnsFailure() {
        // Arrange
        let username = "alice"
        let password = ""

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .failure(let message) = result else {
            return XCTFail("Expected .failure but got .success")
        }
        XCTAssertEqual(message, "Password cannot be empty")
    }

    func test_validate_passwordWithThreeCharacters_returnsFailure() {
        // Arrange — below the minimum length of 4
        let username = "alice"
        let password = "abc"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .failure(let message) = result else {
            return XCTFail("Expected .failure but got .success")
        }
        XCTAssertEqual(message, "Password must be at least 4 characters")
    }

    func test_validate_passwordWithOneCharacter_returnsFailure() {
        // Arrange
        let username = "alice"
        let password = "a"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .failure(let message) = result else {
            return XCTFail("Expected .failure but got .success")
        }
        XCTAssertEqual(message, "Password must be at least 4 characters")
    }

    func test_validate_passwordWithExactlyFourCharacters_returnsSuccess() {
        // Arrange — exactly at the minimum boundary
        let username = "alice"
        let password = "abcd"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .success = result else {
            if case .failure(let message) = result {
                return XCTFail("Expected .success but got .failure(\"\(message)\")")
            }
            return XCTFail("Expected .success")
        }
    }

    func test_validate_passwordWithMoreThanFourCharacters_returnsSuccess() {
        // Arrange
        let username = "alice"
        let password = "securePassword123"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .success = result else {
            if case .failure(let message) = result {
                return XCTFail("Expected .success but got .failure(\"\(message)\")")
            }
            return XCTFail("Expected .success")
        }
    }

    // MARK: - Validation Priority Order

    func test_validate_emptyUsernameAndEmptyPassword_returnsUsernameError() {
        // Arrange — username is checked first; password error must not surface
        let username = ""
        let password = ""

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .failure(let message) = result else {
            return XCTFail("Expected .failure but got .success")
        }
        XCTAssertEqual(message, "Username cannot be empty",
                       "Username validation should be evaluated before password validation")
    }

    func test_validate_emptyUsernameAndShortPassword_returnsUsernameError() {
        // Arrange
        let username = ""
        let password = "ab"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .failure(let message) = result else {
            return XCTFail("Expected .failure but got .success")
        }
        XCTAssertEqual(message, "Username cannot be empty",
                       "Username validation should be evaluated before password length check")
    }

    func test_validate_validUsernameAndEmptyPassword_returnsPasswordEmptyError() {
        // Arrange — empty password is checked before length
        let username = "alice"
        let password = ""

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .failure(let message) = result else {
            return XCTFail("Expected .failure but got .success")
        }
        XCTAssertEqual(message, "Password cannot be empty",
                       "Empty password check should be evaluated before minimum length check")
    }

    // MARK: - Happy Path

    func test_validate_validUsernameAndValidPassword_returnsSuccess() {
        // Arrange
        let username = "alice"
        let password = "password123"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .success = result else {
            if case .failure(let message) = result {
                return XCTFail("Expected .success but got .failure(\"\(message)\")")
            }
            return XCTFail("Expected .success")
        }
    }

    func test_validate_singleCharacterUsername_withValidPassword_returnsSuccess() {
        // Arrange — username length has no minimum; one character is valid
        let username = "a"
        let password = "pass1"

        // Act
        let result = sut.validate(username: username, password: password)

        // Assert
        guard case .success = result else {
            if case .failure(let message) = result {
                return XCTFail("Expected .success but got .failure(\"\(message)\")")
            }
            return XCTFail("Expected .success")
        }
    }

    // MARK: - Protocol Conformance

    func test_loginValidatorImpl_conformsToLoginValidatorProtocol() {
        // Assert
        XCTAssertTrue(sut is LoginValidator,
                      "LoginValidatorImpl must conform to LoginValidator protocol")
    }

    func test_validate_calledThroughProtocol_returnsCorrectResult() {
        // Arrange — reference held as the protocol type to verify substitutability
        let validator: LoginValidator = LoginValidatorImpl()

        // Act
        let result = validator.validate(username: "alice", password: "pass1")

        // Assert
        guard case .success = result else {
            if case .failure(let message) = result {
                return XCTFail("Expected .success but got .failure(\"\(message)\")")
            }
            return XCTFail("Expected .success")
        }
    }
}
