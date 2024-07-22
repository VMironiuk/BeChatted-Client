//
//  MessageView.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 17.07.2024.
//

import SwiftUI

struct MessageView: View {
  var body: some View {
    HStack(alignment: .top) {
      ImageProvider.avatarPrototype
        .clipShape(RoundedRectangle(cornerRadius: 12))
      
      VStack {
        HStack {
          Text("User Name")
            .font(.system(size: 20, weight: .bold))
          
          Text("08:47 AM")
            .font(.system(size: 14))
            .opacity(0.5)
          
          Spacer()
        }
        .padding(.bottom, 2)
        
        Text("User messages will be displayed here. I should be multiline text label.")
      }
    }
  }
}

#Preview {
    MessageView()
}
