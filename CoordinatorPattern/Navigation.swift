//
//  Navigation.swift
//  CoordinatorPattern
//
//  Created by Tran Nguyen on 8/1/22.
//

import Foundation

public enum Navigation<Screen> {
    case push(Screen)
    
    case sheet(Screen, onDismiss: (() -> Void)? = nil)
    
    case cover(Screen, onDismiss: (() -> Void)? = nil)
    
    static func root(screen: Screen) -> Navigation {
        return .sheet(screen, onDismiss: nil)
    }
    
    
    public var screen: Screen {
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
    
    /// Check whether the current screen will need to be embedded in a NavigationView.
    public var needNavigationView: Bool {
        switch self {
        case .sheet, .cover:
            print("NEED NAVVIEW")
            return true
        case .push:
            print("NO NEED NAVVIEW")
            return false
        }
    }
    
    /// To use with the workaround for adding the .sheet() and .fullScreenCover() together in iOS 14.4 and below
    public var isSheet: Bool {
        switch self {
        case .sheet:
            return true
        default:
            return false
        }
    }
}

public typealias NavigationStack<Screen> = [Navigation<Screen>]


public protocol NavigationProtocol {
    associatedtype Screen
    
    static func push(_ screen: Screen) -> Self
    static func sheet(_ screen: Screen, onDismiss: (() -> Void)?) -> Self
    static func cover(_ screen: Screen, onDismiss: (() -> Void)?) -> Self
    var screen: Screen { get set }
    var needNavigationView: Bool { get }
}

extension Navigation: NavigationProtocol {
}
