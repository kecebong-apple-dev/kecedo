//
//  SettingsView.swift
//  kecedo
//
//  Created by Nathan Gitu Loh on 06/04/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("appLanguage") private var appLanguage: String = "English"
    @AppStorage("appFontSize") private var appFontSize: Int = 14
    @AppStorage("appIsLightMode") private var appIsLightMode: Bool = true
    
    // Current state
    @State private var language: String = "English"
    @State private var fontSize: Int = 14
    @State private var isLightMode: Bool = true
    
    // Initial state to track changes
    @State private var initialLanguage: String = "English"
    @State private var initialFontSize: Int = 14
    @State private var initialIsLightMode: Bool = true
    
    @State private var showingConfirmAlert = false
    
    private var hasChanges: Bool {
        language != initialLanguage ||
        fontSize != initialFontSize ||
        isLightMode != initialIsLightMode
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Header")
                .font(.headline)
                .padding(.leading, 8)
                .padding(.top, 16)
            
            VStack(spacing: 0) {
                // Language
                HStack {
                    Text("Language")
                    Spacer()
                    Menu {
                        Button("English") { language = "English" }
                        Button("Indonesian") { language = "Indonesian" }
                        Button("Chinese") { language = "Chinese" }
                    } label: {
                        HStack(spacing: 4) {
                            Text(language)
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                Divider().padding(.horizontal)
                
                // Font Size
                HStack {
                    Text("Font Size")
                    Spacer()
                    
                    Text("\(fontSize)")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                        
                    HStack(spacing: 0) {
                        Button {
                            if fontSize > 10 { fontSize -= 1 }
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 14, weight: .bold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                        }
                        .foregroundColor(.black)
                        
                        Divider()
                            .frame(height: 16)
                        
                        Button {
                            if fontSize < 24 { fontSize += 1 }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                        }
                        .foregroundColor(.black)
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                }
                .padding()
                
                Divider().padding(.horizontal)
                
                // Light Mode
                HStack {
                    Toggle("Light Mode", isOn: $isLightMode)
                        .tint(Color(hex: "#33C65B"))
                }
                .padding()
                
                // Confirm Action Button
                if hasChanges {
                    Divider().padding(.horizontal)
                    
                    Button {
                        showingConfirmAlert = true
                    } label: {
                        Text("Confirm Action")
                            .foregroundColor(Color(hex: "#33C65B"))
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.02), radius: 10, x: 0, y: 4)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            language = appLanguage
            initialLanguage = appLanguage
            fontSize = appFontSize
            initialFontSize = appFontSize
            isLightMode = appIsLightMode
            initialIsLightMode = appIsLightMode
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 36, height: 36)
                }
            }
        }
        .alert("Confirm Changes", isPresented: $showingConfirmAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm") {
                initialLanguage = language
                initialFontSize = fontSize
                initialIsLightMode = isLightMode
                
                appLanguage = language
                appFontSize = fontSize
                appIsLightMode = isLightMode
            }
        } message: {
            Text("Are you sure you want to apply these changes?")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
