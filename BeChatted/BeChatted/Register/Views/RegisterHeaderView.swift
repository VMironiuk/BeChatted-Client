//
//  RegisterHeaderView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.02.2024.
//

//import SwiftUI
//
//struct RegisterHeaderView: View {
//    @Environment(\.isKeyboardShown) var isKeyboardShown
//    @EnvironmentObject var mainNavigationController: MainNavigationController
//    
//    var body: some View {
//        VStack {
//            if !isKeyboardShown {
//                ZStack {
//                    AuthHeaderView(
//                        title: "Register",
//                        subtitle: "Create your Account"
//                    )
//                    
//                    GeometryReader { geometry in
//                        Button {
//                            mainNavigationController.pop()
//                        } label: {
//                            Image(systemName: "chevron.left")
//                                .font(.title)
//                                .foregroundStyle(Color("Auth/Header/TitleColor"))
//                        }
//                        .offset(x: 20, y: 20)
//                    }
//                }
//                .frame(height: 180)
//                .transition(.offset(y: -260))
//            }
//        }
//    }
//}
//
//#Preview {
//    RegisterHeaderView()
//}
