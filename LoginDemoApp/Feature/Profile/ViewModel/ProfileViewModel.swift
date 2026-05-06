import Foundation

class ProfileViewModel: ObservableObject {
    private let service: ProfileService

    init(service: ProfileService) {
        self.service = service
    }
}
