//
//  MatrixFilterSheet.swift
//  kecedo
//

import SwiftUI

struct MatrixFilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var filterState: MatrixFilterState

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Date Filter", selection: $filterState.dateType) {
                        ForEach(DateFilterType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                    
                    if filterState.dateType == .period {
                        DatePicker("Start Date", selection: $filterState.startDate, displayedComponents: .date)
                        DatePicker("End Date", selection: $filterState.endDate, displayedComponents: .date)
                    }
                } header: {
                    Text("Date Filter")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .textCase(nil)
                }
                
                Section {
                    Toggle("Show Completed", isOn: $filterState.showCompleted)
                }
            }
            .navigationTitle("Filter")
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
    MatrixFilterSheet(filterState: .constant(MatrixFilterState()))
}
