import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Text("Profile")
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(service: ProfileServiceImpl()))
}
