import Foundation

protocol LoginService {
    func login(request: LoginRequest) async throws -> LoginResponse
}

class LoginServiceImpl: LoginService {
    
    enum LoginError: Error, LocalizedError {
         case invalidCredentials
         
         var errorDescription: String? {
             switch self {
             case .invalidCredentials:
                 return "Invalid username or password"
             }
         }
     }
     
     func login(request: LoginRequest) async throws -> LoginResponse {
         try await Task.sleep(nanoseconds: 1_000_000_000) // simulate network delay
         
         if request.username == "admin" && request.password == "1234" {
             return LoginResponse(token: "mock_token_123", userName: "Admin User")
         } else {
             throw LoginError.invalidCredentials
         }
     }
    
}
