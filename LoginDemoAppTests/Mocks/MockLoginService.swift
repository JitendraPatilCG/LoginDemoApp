//
//  MockLoginService.swift
//  LoginDemoAppTests
//
//  Created by Jitendra Patil on 06/05/26.
//

import XCTest
@testable import LoginDemoApp

final class MockLoginService: LoginService {
    var stubbedResponse: LoginResponse?
    var stubbedError: Error?
    var loginCallCount = 0
    var capturedRequest: LoginRequest?

    func login(request: LoginRequest) async throws -> LoginResponse {
        loginCallCount += 1
        capturedRequest = request
        if let error = stubbedError { throw error }
        return stubbedResponse!
    }
}
