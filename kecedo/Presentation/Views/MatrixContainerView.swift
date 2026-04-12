//
//  MatrixContainerView.swift
//  kecedo
//
//  Created by Nathan Gitu Loh on 06/04/26.
//

import SwiftUI

struct MatrixContainerView: View {
    @Environment(MatrixViewModel.self) private var matrixViewModel
    
    var body: some View {
        @Bindable var viewModel = matrixViewModel
        NavigationStack {
            Group {
                if viewModel.isListView {
                    MatrixListView(
                        onSettings: { viewModel.navigateToSettings = true },
                        onFilter: { viewModel.showingFilter = true },
                        onSwap: { viewModel.isListView.toggle() }
                    )
                } else {
                    MatrixView(
                        onSettings: { viewModel.navigateToSettings = true },
                        onFilter: { viewModel.showingFilter = true },
                        onSwap: { viewModel.isListView.toggle() }
                    )
                }
            }
            .navigationDestination(isPresented: $viewModel.navigateToSettings) {
                SettingsView()
            }
        }
        .sheet(isPresented: $viewModel.showingFilter) {
            MatrixFilterView(filterState: $viewModel.filterState)
        }
    }
}

#Preview {
    MatrixContainerView()
        .environment(DIContainer().matrixViewModel)
}
