import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel

    init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Text("Dashboard")
    }
}

#Preview {
    DashboardView(viewModel: DashboardViewModel(service: DashboardServiceImpl()))
}
