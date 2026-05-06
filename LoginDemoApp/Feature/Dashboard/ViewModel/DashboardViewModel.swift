import Foundation

class DashboardViewModel: ObservableObject {
    private let service: DashboardService

    init(service: DashboardService) {
        self.service = service
    }
}
