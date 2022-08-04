//
//  Coordinator.swift
//  CoordinatorPattern
//
//  Created by Tran Nguyen on 7/31/22.
//

import Foundation
import SwiftUI


struct Coordinator<Screen, ScreenView: View>: View {
    @Binding var navigationStack: [Navigation<Screen>]
    
    @ViewBuilder var buildScreenView: (Screen, Int) -> ScreenView
    
    init(_ navigationStack: Binding<[Navigation<Screen>]>, @ViewBuilder buildScreenView: @escaping (Screen, Int) -> ScreenView) {
        self._navigationStack = navigationStack
        self.buildScreenView = buildScreenView
    }
    
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
