//
//  Array+Navigation.swift
//  CoordinatorPattern
//
//  Created by Tran Nguyen on 8/3/22.
//

import Foundation

public extension Array where Element: NavigationProtocol {
    mutating func push(_ screen: Element.Screen) {
        append(.push(screen))
    }
    
    mutating func presentSheet(_ screen: Element.Screen, onDismiss: (() -> Void)? = nil) {
        append(.sheet(screen, onDismiss: onDismiss))
    }
    
    mutating func presentCover(_ screen: Element.Screen, onDismiss: (() -> Void)? = nil) {
        append(.cover(screen, onDismiss: onDismiss))
    }
    
    mutating func pop() {
        guard self.count > 0 else { return }
        removeLast()
    }
}


