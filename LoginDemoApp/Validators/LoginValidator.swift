//
//  LoginValidator.swift
//  LoginDemoApp
//
//  Created by Jitendra Patil on 06/05/26.
//

import Foundation

protocol LoginValidator {
    func validate(username: String, password: String) -> ValidationResult
}

enum ValidationResult {
    case success
    case failure(String)
}

final class LoginValidatorImpl: LoginValidator {
    
    func validate(username: String, password: String) -> ValidationResult {
        
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .failure("Username cannot be empty")
        }
        
        if password.isEmpty {
            return .failure("Password cannot be empty")
        }
        
        if password.count < 4 {
            return .failure("Password must be at least 4 characters")
        }
        
        return .success
    }
}
