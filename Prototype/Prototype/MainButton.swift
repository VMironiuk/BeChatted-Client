//
//  MainButton.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 27.10.2023.
//

import SwiftUI

struct MainButton: View {
    @State private var isActive = true
    let title: String

    var body: some View {
        Button {
            
        } label: {
            Text(title)
                .foregroundStyle(
                    isActive ? .white : Color("Auth/MainButtonColor")
                )
                .opacity(isActive ? 1 : 0.8)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("Auth/MainButtonColor"))
                .opacity(isActive ? 1 : 0.15)
        )
        .disabled(!isActive)
    }
}

#Preview {
    MainButton(title: "Main Button")
        .padding(.horizontal, 20)
}
