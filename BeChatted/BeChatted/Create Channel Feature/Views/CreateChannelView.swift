//
//  CreateChannelView.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 23.05.2024.
//

import SwiftUI
import BeChatted

struct CreateChannelView: View {
//    @Bindable private var viewModel: CreateChannelViewModel
    @State private var channelName = ""
    @State private var channelDescription = ""
    private let onCreateChannelButtonTapped: () -> Void
    
    @State private var imageScale: CGFloat = 0.0

    private var isButtonDisabled: Bool {
        false /*!viewModel.isUserInputValid || buttonState == .loading*/
    }
    private var buttonState: PrimaryButtonStyle.State {
//        switch viewModel.state {
//        case .ready, .success: .normal
//        case .inProgress: .loading
//        case .failure: .failed
//        }
        .normal
    }
    private var buttonTitle: String {
        switch buttonState {
        case .normal: "Create Channel"
        case .loading: "Creating Channel ..."
        case .failed: "Failed to Create Channel"
        }
    }
    
    init(/*viewModel: CreateChannelViewModel, */onCreateChannelButtonTapped: @escaping () -> Void) {
//        self.viewModel = viewModel
        self.onCreateChannelButtonTapped = onCreateChannelButtonTapped
    }
    
    var body: some View {
        VStack {
            TextInputView(title: "Channel Name", text: $channelName /*$viewModel.channelName*/)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 52)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            TextInputView(title: "Channel Description", text: $channelDescription /*$viewModel.channelDescription*/)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .autocorrectionDisabled()
            
            Spacer()
            
//            if viewModel.state == .success {
//                successView
//            }
            
            Spacer()
            
            Button(buttonTitle) {
                onCreateChannelButtonTapped()
//                viewModel.createChannel()
            }
            .buttonStyle(PrimaryButtonStyle(state: buttonState, isEnabled: true /*viewModel.isUserInputValid*/))
            .disabled(isButtonDisabled)
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
    }
}

extension CreateChannelView {
    private var successView: some View {
        VStack {
            ImageProvider.createChannelSuccessImage
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("Channel Created!")
                .padding(.top, 20)
                .padding(.bottom)
                .padding(.horizontal, 20)
                .font(.system(size: 24, weight: .semibold))
        }
        .scaleEffect(imageScale)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3).delay(0.3)) {
                imageScale = 1.0
            }
        }
    }
}

private struct FakeCreateChannelService: CreateChannelServiceProtocol {
    func createChannel(
        withName name: String,
        description: String,
        completion: @escaping (Result<Void, BeChatted.CreateChannelServiceError>) -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(.failure(.connectivity))
        }
    }
}
#Preview {
    CreateChannelView(
//        viewModel: CreateChannelViewModel(
//            service: FakeCreateChannelService()
//        ), 
        onCreateChannelButtonTapped: {}
    )
}
