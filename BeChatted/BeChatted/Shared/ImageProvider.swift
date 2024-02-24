//
//  ImageProvider.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 24.02.2024.
//

import SwiftUI

final class ImageProvider {
    private init() {}
    
    static var authRegistrationSuccessImage: Image {
        assetImage(for: "Auth/RegistrationSuccessIcon")
    }
}

private extension ImageProvider {
    private static func assetImage(for name: String) -> Image {
        Image(name, bundle: Bundle(for: self))
    }
}
