//
//  LoginViewModelTests.swift
//  LoginDemoAppTests
//
//  Created by Jitendra Patil on 06/05/26.
//

import XCTest
@testable import LoginDemoApp

// MARK: - LoginViewModelTests

final class LoginViewModelTests: XCTestCase {

    var sut: LoginViewModel!
    var mockService: MockLoginService!
    var mockValidator: MockLoginValidator!

    override func setUp() {
        super.setUp()
        mockService = MockLoginService()
        mockValidator = MockLoginValidator()
        sut = LoginViewModel(service: mockService, validator: mockValidator)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        mockValidator = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func test_initialState_usernameIsEmpty() {
        XCTAssertEqual(sut.username, "")
    }

    func test_initialState_passwordIsEmpty() {
        XCTAssertEqual(sut.password, "")
    }

    func test_initialState_isLoadingIsFalse() {
        XCTAssertFalse(sut.isLoading)
    }

    func test_initialState_errorMessageIsNil() {
        XCTAssertNil(sut.errorMessage)
    }

    func test_initialState_isLoggedInIsFalse() {
        XCTAssertFalse(sut.isLoggedIn)
    }

    // MARK: - Validation Failure

    func test_login_validationFailure_setsErrorMessage() {
        // Arrange
        mockValidator.stubbedResult = .failure("Username cannot be empty")
        sut.username = ""
        sut.password = "pass1"

        // Act
        sut.login()

        // Assert
        XCTAssertEqual(sut.errorMessage, "Username cannot be empty")
    }

    func test_login_validationFailure_doesNotCallService() {
        // Arrange
        mockValidator.stubbedResult = .failure("Username cannot be empty")

        // Act
        sut.login()

        // Assert
        XCTAssertEqual(mockService.loginCallCount, 0)
    }

    func test_login_validationFailure_isLoadingRemainsFalse() {
        // Arrange
        mockValidator.stubbedResult = .failure("Password cannot be empty")

        // Act
        sut.login()

        // Assert
        XCTAssertFalse(sut.isLoading)
    }

    func test_login_validationFailure_isLoggedInRemainsFlase() {
        // Arrange
        mockValidator.stubbedResult = .failure("Password must be at least 4 characters")

        // Act
        sut.login()

        // Assert
        XCTAssertFalse(sut.isLoggedIn)
    }

    func test_login_callsValidator_withCorrectCredentials() {
        // Arrange
        sut.username = "alice"
        sut.password = "pass1"
        mockValidator.stubbedResult = .failure("stop early")

        // Act
        sut.login()

        // Assert
        XCTAssertEqual(mockValidator.capturedUsername, "alice")
        XCTAssertEqual(mockValidator.capturedPassword, "pass1")
    }

    func test_login_clearsExistingErrorMessage_beforeValidation() {
        // Arrange — prime an existing error, then trigger a validation pass to confirm it is cleared
        sut.errorMessage = "stale error"
        mockValidator.stubbedResult = .failure("new error")

        // Act
        sut.login()

        // Assert — errorMessage is overwritten, not stale
        XCTAssertEqual(sut.errorMessage, "new error")
    }

    // MARK: - Successful Login

    func test_login_validationSuccess_callsService() async throws {
        // Arrange
        mockValidator.stubbedResult = .success
        mockService.stubbedResponse = LoginResponse(token: "tok_abc", userName: "Alice")
        sut.username = "alice"
        sut.password = "pass1"

        // Act
        sut.login()
        try await Task.sleep(nanoseconds: 100_000_000)

        // Assert
        XCTAssertEqual(mockService.loginCallCount, 1)
    }

    func test_login_validationSuccess_passesCorrectRequestToService() async throws {
        // Arrange
        mockValidator.stubbedResult = .success
        mockService.stubbedResponse = LoginResponse(token: "tok_abc", userName: "Alice")
        sut.username = "alice"
        sut.password = "pass1"

        // Act
        sut.login()
        try await Task.sleep(nanoseconds: 100_000_000)

        // Assert
        let captured = try XCTUnwrap(mockService.capturedRequest)
        XCTAssertEqual(captured.username, "alice")
        XCTAssertEqual(captured.password, "pass1")
    }

    func test_login_serviceSuccess_setsIsLoggedInTrue() async throws {
        // Arrange
        mockValidator.stubbedResult = .success
        mockService.stubbedResponse = LoginResponse(token: "tok_abc", userName: "Alice")

        // Act
        sut.login()
        try await Task.sleep(nanoseconds: 100_000_000)

        // Assert
        XCTAssertTrue(sut.isLoggedIn)
    }

    func test_login_serviceSuccess_errorMessageRemainsNil() async throws {
        // Arrange
        mockValidator.stubbedResult = .success
        mockService.stubbedResponse = LoginResponse(token: "tok_abc", userName: "Alice")

        // Act
        sut.login()
        try await Task.sleep(nanoseconds: 100_000_000)

        // Assert
        XCTAssertNil(sut.errorMessage)
    }

    func test_login_serviceSuccess_isLoadingReturnsFalse() async throws {
        // Arrange
        mockValidator.stubbedResult = .success
        mockService.stubbedResponse = LoginResponse(token: "tok_abc", userName: "Alice")

        // Act
        sut.login()
        try await Task.sleep(nanoseconds: 100_000_000)

        // Assert
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Service Failure

    func test_login_serviceFailure_setsErrorMessage() async throws {
        // Arrange
        mockValidator.stubbedResult = .success
        mockService.stubbedError = NSError(
            domain: "LoginError",
            code: 401,
            userInfo: [NSLocalizedDescriptionKey: "Invalid username or password"]
        )

        // Act
        sut.login()
        try await Task.sleep(nanoseconds: 100_000_000)

        // Assert
        XCTAssertEqual(sut.errorMessage, "Invalid username or password")
    }

    func test_login_serviceFailure_isLoggedInRemainsFlase() async throws {
        // Arrange
        mockValidator.stubbedResult = .success
        mockService.stubbedError = NSError(domain: "LoginError", code: 401)

        // Act
        sut.login()
        try await Task.sleep(nanoseconds: 100_000_000)

        // Assert
        XCTAssertFalse(sut.isLoggedIn)
    }

    func test_login_serviceFailure_isLoadingReturnsFalse() async throws {
        // Arrange
        mockValidator.stubbedResult = .success
        mockService.stubbedError = NSError(domain: "LoginError", code: 401)

        // Act
        sut.login()
        try await Task.sleep(nanoseconds: 100_000_000)

        // Assert
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Published Property Mutations

    func test_username_canBeUpdated() {
        // Act
        sut.username = "newUser"

        // Assert
        XCTAssertEqual(sut.username, "newUser")
    }

    func test_password_canBeUpdated() {
        // Act
        sut.password = "newPass"

        // Assert
        XCTAssertEqual(sut.password, "newPass")
    }

    // MARK: - Validator Invocation Count

    func test_login_calledTwice_invokesValidatorTwice() {
        // Arrange
        mockValidator.stubbedResult = .failure("stop")

        // Act
        sut.login()
        sut.login()

        // Assert
        XCTAssertEqual(mockValidator.validateCallCount, 2)
    }

    // MARK: - Protocol Conformance

    func test_loginViewModel_conformsToObservableObject() {
        XCTAssertTrue(sut is (any ObservableObject))
    }
}
