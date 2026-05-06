import Foundation

class LoginViewModel: ObservableObject {
    private let service: LoginService
    private let validator: LoginValidator
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
        
    init(
        service: LoginService = LoginServiceImpl(),
        validator: LoginValidator = LoginValidatorImpl()
    ) {
        self.service = service
        self.validator = validator
    }
    
    func login() {
           errorMessage = nil
           
           // ✅ Validation first
           switch validator.validate(username: username, password: password) {
           case .failure(let message):
               errorMessage = message
               return
           case .success:
               break
           }
           
           isLoading = true
           
           Task {
               do {
                   let response = try await service.login(
                       request: LoginRequest(username: username, password: password)
                   )
                   
                   print("Token:", response.token)
                   isLoggedIn = true
                   
               } catch {
                   errorMessage = error.localizedDescription
               }
               
               isLoading = false
           }
       }
}
