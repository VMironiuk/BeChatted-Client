//
//  ChannelsView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import SwiftUI

struct ChannelsView: View {
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(0..<20) { item in
                        if item == .zero {
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .foregroundStyle(Color.gray)
                                    .frame(width: 180, height: 18)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 64)
                                    .padding(.bottom, 24)
                                Spacer()
                            }
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color.teal)
                                    .frame(height: 52)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 8)
                            }
                        }
                    }
                } header: {
                    ZStack {
                        Rectangle()
                            .frame(height: 82)
                            .foregroundStyle(Color.white)
                        VStack {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color.green)
                                .frame(height: 50)
                                .padding(16)
                            Divider()
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
        .navigationTitle("Channels")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    ImageProvider.avatarPrototype
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChannelsView()
    }
}
