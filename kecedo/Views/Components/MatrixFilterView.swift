//
//  MatrixFilterSheet.swift
//  kecedo
//
//  Created by Nathan Gitu Loh on 06/04/26.
//

import SwiftUI

struct MatrixFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("appLanguage") private var appLanguage: String = "English"
    @Binding var filterState: MatrixFilterState

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Date Filter".localized(appLanguage), selection: $filterState.dateType) {
                        ForEach(DateFilterType.allCases) { type in
                            Text(type.rawValue.localized(appLanguage)).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                    
                    if filterState.dateType == .period {
                        DatePicker("Start Date".localized(appLanguage), selection: $filterState.startDate, displayedComponents: .date)
                        DatePicker("End Date".localized(appLanguage), selection: $filterState.endDate, displayedComponents: .date)
                    }
                } header: {
                    Text("Date Filter".localized(appLanguage))
                        .font(.headline)
                        .foregroundColor(.primary)
                        .textCase(nil)
                }
                
                Section {
                    Toggle("Show Completed".localized(appLanguage), isOn: $filterState.showCompleted)
                }
            }
            .navigationTitle("Filter".localized(appLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
            }
        }
    }
}

#Preview {
    MatrixFilterView(filterState: .constant(MatrixFilterState()))
}
