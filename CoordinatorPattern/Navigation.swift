//
//  Navigation.swift
//  CoordinatorPattern
//
//  Created by Tran Nguyen on 8/1/22.
//

import Foundation

enum Navigation<Screen> {
    case push(Screen)
    
    case sheet(Screen, onDismiss: (() -> Void)? = nil)
    
    case cover(Screen, onDismiss: (() -> Void)? = nil)
    
    static func root(screen: Screen) -> Navigation {
        return .sheet(screen, onDismiss: nil)
    }
    
    
    var screen: Screen {
        get {
            switch self {
            case .push(let screen), .sheet(let screen, _), .cover(let screen, _):
                return screen
            }
        }
        
        set {
            switch self {
            case .push:
                self = .push(newValue)
            case .sheet(_, let onDismiss):
                self = .sheet(newValue, onDismiss: onDismiss)
            case .cover(_, onDismiss: let onDismiss):
                self = .cover(newValue, onDismiss: onDismiss)
            }
        }
    }
}
