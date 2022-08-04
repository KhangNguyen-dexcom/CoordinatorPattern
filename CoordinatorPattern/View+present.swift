//
//  View+present.swift
//  CoordinatorPattern
//
//  Created by Tran Nguyen on 8/4/22.
//

import Foundation
import SwiftUI

extension View {
    
    /// On iOS 14.4 and below, you cannot have both .sheet() and .fullScreenCover() together. So we create a workaround by using
    /// a condition that toggles between either adding a sheet modifer or a fullScreenCover modifier.
    @ViewBuilder
    func present<Content: View>(asSheet: Bool, isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View {
      if asSheet {
        self.sheet(
          isPresented: isPresented,
          onDismiss: nil,
          content: content
        )
      } else {
        self.fullScreenCover(
          isPresented: isPresented,
          onDismiss: nil,
          content: content
        )
      }
    }
}

