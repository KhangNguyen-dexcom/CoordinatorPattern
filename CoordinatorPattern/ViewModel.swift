//
//  ViewModel.swift
//  CoordinatorPattern
//
//  Created by Tran Nguyen on 8/3/22.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var navigationStack: NavigationStack<Screen>
    
    init() {
        navigationStack = []
        navigationStack.push(.moreInfo)
    }
    
    enum Screen {
        case home
        case lilly
        case moreInfo
    }
}
