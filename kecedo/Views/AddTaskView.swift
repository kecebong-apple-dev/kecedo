//
//  AddTaskView.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 07/04/26.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var matrix: Priority? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 14) {
                    TextField("Title", text: $title)
                        .inputFieldStyle()
                    ZStack (alignment: .bottomTrailing) {
                        TextField("Description", text: $desc, axis: .vertical)
                            .lineLimit(4...4)
                            .inputFieldStyle()
                        Button {
                            //
                        } label: {
                            HStack {
                                Image(systemName: "camera.viewfinder")
                                    .foregroundStyle(.white)
                                
                                Text("Scan")
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 99))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 6)
                    }
                    
                    DatePicker("Start Date", selection: $startDate, in: Date()...)
                        .inputFieldStyle()
                    
                    DatePicker("End Date", selection: $startDate, in: Date()...)
                        .inputFieldStyle()
                    
                    Text("Matrix Area").fontWeight(.bold).font(.title2).padding(.horizontal, 16).padding(.top, 6)
                    HStack {
                        Button {
                            matrix = .doFirst
                        } label: {
                            MatrixGridIcon(mode: .doFirst)
                                .frame(width: 36, height: 36)
                        }
                        .gridIconStyle(isActive: matrix == .doFirst)
                        Spacer()
                        Button {
                            matrix = .schedule
                        } label: {
                            MatrixGridIcon(mode: .schedule)
                                .frame(width: 36, height: 36)
                        }
                        .gridIconStyle(isActive: matrix == .schedule)
                        Spacer()
                        Button {
                            matrix = .delegate
                        } label: {
                            MatrixGridIcon(mode: .delegate)
                                .frame(width: 36, height: 36)
                        }
                        .gridIconStyle(isActive: matrix == .delegate)
                        Spacer()
                        Button {
                            matrix = .eliminate
                        } label: {
                            MatrixGridIcon(mode: .eliminate)
                                .frame(width: 36, height: 36)
                        }
                        .gridIconStyle(isActive: matrix == .eliminate)
                    }
                    
                    .padding(.horizontal, 36)
                    
                }
                .navigationTitle("New Task")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.gray.opacity(0.4))
                        .clipShape(Circle())
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            //
                        } label: {
                            Image(systemName: "checkmark")
                        }
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                    }
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    AddTaskView()
}
