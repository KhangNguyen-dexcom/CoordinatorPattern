//
//  Array+Navigation.swift
//  CoordinatorPattern
//
//  Created by Tran Nguyen on 8/3/22.
//

import Foundation

public extension Array where Element: NavigationProtocol {
    /// Push a new screen to the navigation stack and transition to that screen.
    /// - Parameter screen: The screen to be displayed.
    mutating func push(_ screen: Element.Screen) {
        append(.push(screen))
    }
    
    /// Present a sheet to the current screen.
    /// - Parameters:
    ///   - screen: The screen to be displayed as a sheet
    ///   - onDismiss: Actions to be done on dismissal. Default to nil
    mutating func presentSheet(_ screen: Element.Screen, onDismiss: (() -> Void)? = nil) {
        append(.sheet(screen, onDismiss: onDismiss))
    }
    
    /// Present a full screen cover to the current screen.
    /// - Parameters:
    ///   - screen: The screen to be displayed as a cover
    ///   - onDismiss: Actions to be done on dismissal. Default to nil
    mutating func presentCover(_ screen: Element.Screen, onDismiss: (() -> Void)? = nil) {
        append(.cover(screen, onDismiss: onDismiss))
    }
    
    /// Remove the top screen from the navigation stack.
    mutating func pop() {
        guard self.count > 0 else { return }
        removeLast()
    }
}


