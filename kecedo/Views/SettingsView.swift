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
            VStack(spacing: 0) {
                // Language
                HStack {
                    Text("Language".localized(language))
                    Spacer()
                    Menu {
                        Button("English".localized(language)) { language = "English" }
                        Button("Indonesian".localized(language)) { language = "Indonesian" }
                        Button("Chinese".localized(language)) { language = "Chinese" }
                    } label: {
                        HStack(spacing: 4) {
                            Text(language.localized(language))
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                Divider().padding(.horizontal)
                
                // Light Mode
                HStack {
                    Toggle("Night Mode".localized(language), isOn: Binding(
                        get: { !isLightMode },
                        set: { isLightMode = !$0 }
                    ))
                        .tint(Color(hex: "#33C65B"))
                }
                .padding()
                
                // Confirm Action Button
                if hasChanges {
                    Divider().padding(.horizontal)
                    
                    Button {
                        showingConfirmAlert = true
                    } label: {
                        Text("Confirm Action".localized(language))
                            .foregroundColor(Color(hex: "#33C65B"))
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
            }
            .background(Color(UIColor.systemBackground))
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
        .navigationTitle("Settings".localized(language))
        .navigationBarTitleDisplayMode(.inline)
        .alert("Confirm Changes".localized(language), isPresented: $showingConfirmAlert) {
            Button("Cancel".localized(language), role: .cancel) { }
            Button("Confirm".localized(language)) {
                initialLanguage = language
                initialFontSize = fontSize
                initialIsLightMode = isLightMode
                
                appLanguage = language
                appFontSize = fontSize
                appIsLightMode = isLightMode
            }
        } message: {
            Text("Are you sure you want to apply these changes?".localized(language))
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
