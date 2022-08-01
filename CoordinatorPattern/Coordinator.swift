//
//  Coordinator.swift
//  CoordinatorPattern
//
//  Created by Tran Nguyen on 7/31/22.
//

import Foundation
import SwiftUI


struct Coordinator<Screen, ScreenView>: View {
    @Binding var navigationStack: [Navigation<Screen>]
    
    var body: some View {
        EmptyView()
    }
}
