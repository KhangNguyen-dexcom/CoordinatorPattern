//
//  ContentView.swift
//  CoordinatorPattern
//
//  Created by Tran Nguyen on 7/31/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            Coordinator($viewModel.navigationStack) { $screen, _ in
                switch screen {
                case .home:
                    HomeView(viewModel: viewModel)
                case .lilly:
                    LillyView(viewModel: viewModel)
                case .moreInfo:
                    MoreInfoView(viewModel: viewModel)
                }
            }
        }
    }
    

}
struct HomeView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack {
            Text("Home View")
                .padding()
            Button("Go Lilly") {
                viewModel.navigationStack.push(.lilly)
            }
            Button("Go Lilly sheet") {
                viewModel.navigationStack.presentSheet(.lilly)
            }
        }
    }
}

struct LillyView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack {
            Text("Lilly View")
                .padding()
            Button("Go home") {
                viewModel.navigationStack.push(.home)
            }
            Button("Go more info") {
                viewModel.navigationStack.push(.moreInfo)
            }
            Button("Go Lilly sheet") {
                viewModel.navigationStack.presentSheet(.lilly)
            }
        }
    }
}

struct MoreInfoView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack {
            Text("More info View")
                .padding()
            Button("Go home") {
                viewModel.navigationStack.push(.home)
            }
            Button("Go Lilly") {
                viewModel.navigationStack.push(.lilly)
            }
            Button("Go Lilly sheet") {
                viewModel.navigationStack.presentSheet(.lilly)
            }
        }
    }
}
