//
//  CreateChannelView.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 23.05.2024.
//

import SwiftUI
import BeChatted

struct CreateChannelView: View {
    @Bindable private var viewModel: CreateChannelViewModel

    private var isButtonDisabled: Bool {
        !viewModel.isUserInputValid || buttonState == .loading
    }
    private var buttonState: PrimaryButtonStyle.State {
        switch viewModel.state {
        case .ready, .success: .normal
        case .inProgress: .loading
        case .failure: .failed
        }
    }
    private var buttonTitle: String {
        switch buttonState {
        case .normal: "Create Channel"
        case .loading: "Creating Channel ..."
        case .failed: "Failed to Create Channel"
        }
    }
    
    init(viewModel: CreateChannelViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            TextInputView(title: "Channel Name", text: $viewModel.channelName)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 52)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            TextInputView(title: "Channel Description", text: $viewModel.channelDescription)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .autocorrectionDisabled()
            
            Spacer()
            
            Button(buttonTitle) {
                viewModel.createChannel()
            }
            .buttonStyle(PrimaryButtonStyle(state: buttonState, isEnabled: viewModel.isUserInputValid))
            .disabled(isButtonDisabled)
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
            .animation(.easeInOut(duration: 0.2), value: buttonState)
        }
    }
}

private struct FakeCreateChannelService: CreateChannelServiceProtocol {
    func createChannel(
        withName name: String,
        description: String,
        completion: @escaping (Result<Void, BeChatted.CreateChannelServiceError>) -> Void
    ) {
    }
}
#Preview {
    CreateChannelView(
        viewModel: CreateChannelViewModel(
            service: FakeCreateChannelService()
        )
    )
}
