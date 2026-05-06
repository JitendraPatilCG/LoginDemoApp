import Foundation

struct LoginRequest {
    let username: String
    let password: String
}

struct LoginResponse {
    let token: String
    let userName: String
}
