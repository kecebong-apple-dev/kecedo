//
//  MatrixContainerView.swift
//  kecedo
//

import SwiftUI

struct MatrixContainerView: View {
    @State private var isListView = false
    @State private var filterState = MatrixFilterState()
    
    @State private var showingFilter = false
    @State private var navigateToSettings = false
    
    var body: some View {
        NavigationStack {
            Group {
                if isListView {
                    MatrixListView(
                        filterState: filterState,
                        onSettings: { navigateToSettings = true },
                        onFilter: { showingFilter = true },
                        onSwap: { isListView.toggle() }
                    )
                } else {
                    MatrixView(
                        filterState: filterState,
                        onSettings: { navigateToSettings = true },
                        onFilter: { showingFilter = true },
                        onSwap: { isListView.toggle() }
                    )
                }
            }
            .navigationDestination(isPresented: $navigateToSettings) {
                SettingsView()
            }
        }
        .sheet(isPresented: $showingFilter) {
            MatrixFilterView(filterState: $filterState)
        }
    }
}
