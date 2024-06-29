//
//  ProfileView.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 26.06.2024.
//

import SwiftUI
import BeChatted

struct ProfileView: View {
  @ObservedObject private var viewModel: ProfileViewModel
  
  init(viewModel: ProfileViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack {
      header
      
      Divider()
            
      List {
        userInfo
        logoutButton
      }
      .listStyle(.plain)
      .padding(.top, -8)
    }
  }
}

extension ProfileView {
  private var header: some View {
    VStack {
      ZStack {
        Text("Profile")
          .font(.title2)
          .fontWeight(.medium)
        
        HStack {
          Button {
          } label: {
            Image(systemName: "xmark")
              .foregroundStyle(.black)
              .font(.system(size: 32, weight: .thin))
          }
          .padding(.horizontal)
          Spacer()
        }
      }
    }
    .frame(height: 64)
  }
}

extension ProfileView {
  private var userInfo: some View {
    HStack {
      ImageProvider.avatarPrototype
        .resizable()
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      
      VStack(alignment: .leading) {
        Text("Luka Rask")
          .font(.system(size: 28, weight: .bold))
        Text(verbatim: "luka.rusk@example.com")
          .font(.system(size: 16, weight: .thin))
      }
      .padding(.horizontal)
    }
    .listRowSeparator(.hidden)
  }
}

extension ProfileView {
  private var logoutButton: some View {
    Button("Logout") {
    }
    .buttonStyle(SecondaryButtonStyle())
  }
}

private struct FakeAuthService: AuthServiceProtocol {
  func login(
    _ payload: LoginPayload,
    completion: @escaping (Result<LoginInfo, AuthError>) -> Void
  ) {
  }
  
  func createAccount(
    _ payload: CreateAccountPayload,
    completion: @escaping (Result<Void, AuthError>) -> Void
  ) {
  }
  
  func addUser(
    _ payload: AddUserPayload,
    authToken: String,
    completion: @escaping (Result<AddedUserInfo, AuthError>) -> Void
  ) {
  }
  
  func logout(
    authToken: String,
    completion: @escaping (Result<Void, any Error>) -> Void
  ) {
  }
}

#Preview {
  ProfileView(
    viewModel: ProfileViewModel(
      service: FakeAuthService(),
      authToken: "any token",
      onLogoutAction: {}
    )
  )
}
