//
//  SettingsView.swift
//  kecedo
//
//  Created by Nathan Gitu Loh on 06/04/26.
//

import SwiftUI

enum ThemeMode: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var systemColorScheme
    
    @AppStorage("appLanguage") private var appLanguage: String = "English"
    @AppStorage("appFontSize") private var appFontSize: Int = 14
    @AppStorage("appIsLightMode") private var appIsLightMode: Bool = true
    @AppStorage("useSystemTheme") private var useSystemTheme: Bool = true
    
    // Current state (Draft)
    @State private var language: String = "English"
    @State private var fontSize: Int = 14
    @State private var theme: ThemeMode = .system
    
    // Initial state to track changes
    @State private var initialLanguage: String = "English"
    @State private var initialFontSize: Int = 14
    @State private var initialTheme: ThemeMode = .system
    
    @State private var showingConfirmAlert = false
    
    private var hasChanges: Bool {
        language != initialLanguage ||
        fontSize != initialFontSize ||
        theme != initialTheme
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Header".localized(language))
                .font(.headline)
                .padding(.leading, 8)
                .padding(.top, 16)
            
            VStack(spacing: 0) {
                // Language Menu
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
                
                // Theme Picker (Tampilan Segmented / Button Group)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Theme".localized(language))
                    
                    Picker("Theme", selection: $theme) {
                        Text("System".localized(language)).tag(ThemeMode.system)
                        Text("Light".localized(language)).tag(ThemeMode.light)
                        Text("Dark".localized(language)).tag(ThemeMode.dark)
                    }
                    .pickerStyle(.segmented)
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
            // Setup bahasa & font
            language = appLanguage
            initialLanguage = appLanguage
            fontSize = appFontSize
            initialFontSize = appFontSize
            
            if useSystemTheme {
                theme = .system
            } else {
                theme = appIsLightMode ? .light : .dark
            }
            initialTheme = theme
        }
        .navigationTitle("Settings".localized(language))
        .navigationBarTitleDisplayMode(.inline)
        .alert("Confirm Changes".localized(language), isPresented: $showingConfirmAlert) {
            Button("Cancel".localized(language), role: .cancel) { }
            Button("Confirm".localized(language)) {
                // Update Initial States
                initialLanguage = language
                initialFontSize = fontSize
                initialTheme = theme
                
                // Save Language & Font
                appLanguage = language
                appFontSize = fontSize
                
                switch theme {
                case .system:
                    useSystemTheme = true
                    appIsLightMode = (systemColorScheme == .light)
                case .light:
                    useSystemTheme = false
                    appIsLightMode = true
                case .dark:
                    useSystemTheme = false
                    appIsLightMode = false
                }
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
