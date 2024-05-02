//
//  ChannelTitleView.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 01.05.2024.
//

import SwiftUI

struct ChannelTitleView: View {
    var body: some View {
        HStack {
            Text("Recommended channels")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(ColorProvider.recommendedChannelsLabelColor)
                .padding(.horizontal, 16)
                .padding(.top, 64)
                .padding(.bottom, 24)
            Spacer()
        }
    }
}

#Preview {
    ChannelTitleView()
}
