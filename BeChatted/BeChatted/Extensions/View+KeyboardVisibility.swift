//
//  View+KeyboardVisibility.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.12.2023.
//

import SwiftUI
import Combine

extension View {
    func addKeyboardVisibilityToEnvironment() -> some View {
        modifier(KeyboardVisibility())
    }
}

private struct IsKeyboardShownEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isKeyboardShown: Bool {
        get { self[IsKeyboardShownEnvironmentKey.self] }
        set { self[IsKeyboardShownEnvironmentKey.self] = newValue }
    }
}

private struct KeyboardVisibility: ViewModifier {
    @State private var isKeyboardShown: Bool = false
    
    private var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .Merge(
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .map { _ in true},
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false }
            )
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    fileprivate func body(content: Content) -> some View {
        content
            .environment(\.isKeyboardShown, isKeyboardShown)
            .onReceive(keyboardPublisher) { value in
                withAnimation { isKeyboardShown = value }
            }
    }
}
