//
//  NavigationItem.swift
//  CoordinatorPattern
//
//  Created by Tran Nguyen on 8/1/22.
//

import Foundation
import SwiftUI

indirect enum NavigationItem<Screen, ScreenView: View>: View {
    
    case navigation(Navigation<Screen>, next: NavigationItem<Screen, ScreenView>, navigationStack: Binding<[Navigation<Screen>]>, index: Int, buildScreenView: (Screen) -> ScreenView)
    case end
    
    private var navigation: Navigation<Screen>? {
        switch self {
        case .navigation(let navigation, next: _, navigationStack: _, index: _, buildScreenView: _):
            return navigation
        case .end:
            return nil
        }
    }
    
    private var next: NavigationItem? {
        switch self {
        case .navigation(_, next: let next, navigationStack: _, index: _, buildScreenView: _):
            return next
        case .end:
            return nil
        }
    }
                    
    @ViewBuilder private var screenView: some View {
        switch self {
        case .navigation(let navigation, next: _, navigationStack: _, index: _, buildScreenView: let buildScreenView):
            buildScreenView(navigation.screen)
        case .end:
            EmptyView()
        }
    }
    
    private var isActive: Binding<Bool> {
        switch self {
        case .navigation(let navigation, next: .navigation, let navigationStack, let index, _):
            return Binding(
                get: {
//                    print("navigation\(String(describing: navigation)), value: \(navigationStack.wrappedValue.count > index + 1)")
                    return navigationStack.wrappedValue.count > index + 1
                },
                set: { isPresented in
                    guard !isPresented else {
                        return
                    }
                    guard navigationStack.wrappedValue.count > index + 1 else {
                        return
                    }
                    navigationStack.wrappedValue = Array(navigationStack.wrappedValue.prefix(index + 1))
                }
            )
        default:
            return .constant(false)
        }
    }
    
    private var isPushActive: Binding<Bool> {
        switch next {
        case .navigation(.push, next: _, navigationStack: _, index: _, buildScreenView: _):
            return isActive
        default:
            return .constant(false)
        }
    }
    
    private var isSheetActive: Binding<Bool> {
        switch next {
        case .navigation(.sheet, next: _, navigationStack: _, index: _, buildScreenView: _):
            print("SheetActive")
            return isActive
        default:
            return .constant(false)
        }
    }
    
    private var isCoverActive: Binding<Bool> {
        switch next {
        case .navigation(.cover, next: _, navigationStack: _, index: _, buildScreenView: _):
            return isActive
        default:
            return .constant(false)
        }
    }
    
    
    private var onDismiss: (() -> Void)? {
        switch next {
        case .navigation(.sheet(_, let onDismiss), _, _, _, _), .navigation(.cover(_, let onDismiss), _, _, _, _):
            return onDismiss
        default:
            return nil
        }
    }
    
    @ViewBuilder
    var unwrappedView: some View {
        /// On iOS 14.4 and below, you cannot have both .sheet() and .fullScreenCover() together. So we create a workaround by using
        /// a condition that toggles between either adding a sheet modifer or a fullScreenCover modifier.
        if #available(iOS 14.5, *) {
            screenView
                .background(
                    NavigationLink(destination: next, isActive: isPushActive, label: { EmptyView() })
                        .hidden()
                )
                .sheet(
                    isPresented: isSheetActive,
                    onDismiss: onDismiss,
                    content: { next }
                )
                .fullScreenCover(
                    isPresented: isCoverActive,
                    onDismiss: onDismiss,
                    content: { next }
                )
        } else {
            let asSheet = next?.navigation?.isSheet ?? false
            screenView
                .background(
                    NavigationLink(destination: next, isActive: isPushActive, label: { EmptyView() })
                        .hidden()
                )
                .present(
                    asSheet: asSheet,
                    isPresented: asSheet ? isSheetActive : isCoverActive,
                    onDismiss: onDismiss,
                    content: { next }
                )
        }
    }

    var body: some View {
        if navigation!.needNavigationView {
            NavigationView {
                unwrappedView
            }
        } else {
            unwrappedView
        }
    }
}
