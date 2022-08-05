//
//  Coordinator.swift
//  CoordinatorPattern
//
//  Created by Tran Nguyen on 7/31/22.
//

import Foundation
import SwiftUI


/// The coordinator struct uses a navigation stack to display a view
struct Coordinator<Screen, ScreenView: View>: View {
    @Binding var navigationStack: [Navigation<Screen>]
    
    @ViewBuilder var buildScreenView: (Screen, Int) -> ScreenView
    
    /// Create a Coordinator using a Binding to a navigation stack (an array of Screen)
    /// - Parameters:
    ///   - navigationStack: A binding to an array of Screen
    ///   - buildScreenView: A closure that builds a ScreenView from a Screen and its index
    init(_ navigationStack: Binding<[Navigation<Screen>]>, @ViewBuilder buildScreenView: @escaping (Screen, Int) -> ScreenView) {
        self._navigationStack = navigationStack
        self.buildScreenView = buildScreenView
    }
    
    /// Create a Coordinator using a Binding to a navigation stack (an array of Screen). This is useful when the Screen have a value that will be changed.
    /// - Parameters:
    ///   - navigationStack: A binding to an array of Screen
    ///   - buildScreenView: A closure that builds a ScreenView from a Binding to a Screen and its index
    init(_ navigationStack: Binding<[Navigation<Screen>]>, @ViewBuilder buildScreenView: @escaping (Binding<Screen>, Int) -> ScreenView) {
        self._navigationStack = navigationStack
        self.buildScreenView = { _, index in
            let screenBinding = Binding<Screen>(
                get: {
                    navigationStack.wrappedValue[index].screen
                },
                set: {
                    navigationStack.wrappedValue[index].screen = $0
                }
            )
            return buildScreenView(screenBinding, index)
        }
    }
    
    var body: some View {
        navigationStack
            .enumerated()
            .reversed()
            .reduce(NavigationItem<Screen, ScreenView>.end) { navItem, enumerated in
                let (index, navigation) = enumerated
                return NavigationItem<Screen, ScreenView>
                    .navigation(
                        navigation,
                        next: navItem,
                        navigationStack: $navigationStack,
                        index: index,
                        buildScreenView: { screen in
                            buildScreenView(screen, index)
                        }
                    )
            }
    }
}
