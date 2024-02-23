//
//  ColorProvider.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import SwiftUI

final class ColorProvider {
    private init() {}
    static var authMainButtonColor: Color {
        Color("Auth/MainButtonColor", bundle: Bundle(for: self))
    }
    static  var authBottomLabelColor: Color {
        Color("Auth/BottomLabelColor", bundle: Bundle(for: self))
    }
}
