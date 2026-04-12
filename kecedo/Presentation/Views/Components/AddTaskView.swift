//
//  AddTaskView.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 07/04/26.
//

import SwiftUI
import Vision

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(TaskViewModel.self) private var taskViewModel
    @AppStorage("appLanguage") private var appLanguage: String = "English"
    
    var taskToEdit: TaskEntity?
    
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var matrix: Priority = .doFirst
    
    @State private var showImageSourceDialog: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var selectedImage: UIImage? = nil
    
    @State private var showDeleteConfirmation: Bool = false
    @State private var showDiscardConfirmation: Bool = false
    
    private var hasChanges: Bool {
        if let task = taskToEdit {
            return title != task.title ||
            desc != task.desc ||
            startDate != task.startDate ||
            endDate != task.endDate ||
            matrix != task.priority
        } else {
            return !title.isEmpty || !desc.isEmpty
        }
    }
    
    init(taskToEdit: TaskEntity? = nil) {
        self.taskToEdit = taskToEdit
        
        _title = State(initialValue: taskToEdit?.title ?? "")
        _desc = State(initialValue: taskToEdit?.desc ?? "")
        _startDate = State(initialValue: taskToEdit?.startDate ?? Date())
        _endDate = State(initialValue: taskToEdit?.endDate ?? Date())
        _matrix = State(initialValue: taskToEdit?.priority ?? .doFirst)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 14) {
                    TextField("Title".localized(appLanguage), text: $title)
                        .inputFieldStyle()
                    ZStack (alignment: .bottomTrailing) {
                        TextField("Description".localized(appLanguage), text: $desc, axis: .vertical)
                            .lineLimit(4...4)
                            .inputFieldStyle()
                        if desc.isEmpty {
                            Button {
                                showImageSourceDialog = true
                            } label: {
                                HStack {
                                    Image(systemName: "camera.viewfinder")
                                        .foregroundStyle(.white)
                                    
                                    Text("Scan".localized(appLanguage))
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 99))
                            .padding(.horizontal, 22)
                            .padding(.vertical, 6)
                            .confirmationDialog("Choose Image Source".localized(appLanguage), isPresented: $showImageSourceDialog, titleVisibility: .visible) {
                                Button("Camera".localized(appLanguage)) {
                                    imageSourceType = .camera
                                    showImagePicker = true
                                }
                                Button("Photo Library".localized(appLanguage)) {
                                    imageSourceType = .photoLibrary
                                    showImagePicker = true
                                }
                                Button("Cancel".localized(appLanguage), role: .cancel) {}
                            }
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(sourceType: imageSourceType, selectedImage: $selectedImage)
                            }
                            .onChange(of: selectedImage) {
                                _, newValue in
                                if let newImage = newValue {
                                    processImageForText(newImage)
                                }
                            }
                        }
                    }
                    
                    DatePicker("Start Date".localized(appLanguage), selection: $startDate, in: ...endDate)
                        .inputFieldStyle()
                    
                    DatePicker("End Date".localized(appLanguage), selection: $endDate, in: startDate...)
                        .inputFieldStyle()
                    
                    Text("Matrix Area".localized(appLanguage)).fontWeight(.bold).font(.title2).padding(.horizontal, 16).padding(.top, 6)
                    HStack {
                        ForEach([Priority.doFirst, Priority.schedule, Priority.delegate, Priority.eliminate], id: \.self) { priority in
                            Button {
                                withAnimation {
                                    matrix = priority
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(matrix == priority ? priority.color.secondary : .white)
                                        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                                    
                                    MatrixGridBadge(priority: priority)
                                        .frame(width: 28, height: 28)
                                }
                                .frame(width: 60, height: 60)
                            }
                            .buttonStyle(.plain)
                            
                            if priority != .eliminate {
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    if taskToEdit != nil {
                        Button {
                            showDeleteConfirmation = true
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "trash")
                                Text("Delete Task".localized(appLanguage))
                                Spacer()
                            }
                        }
                        .padding()
                        .foregroundStyle(.red)
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 36)
                        .padding(.top, 20)
                        .confirmationDialog("Delete Task".localized(appLanguage), isPresented: $showDeleteConfirmation) {
                            Button("Delete".localized(appLanguage), role: .destructive) {
                                deleteTask()
                            }
                            Button("Cancel".localized(appLanguage), role: .cancel) {}
                        } message: {
                            Text("Are you sure you want to delete this task? This action is irreversible.".localized(appLanguage))
                        }
                    }
                    
                }
                .navigationTitle(taskToEdit == nil ? "New Task".localized(appLanguage) : "Task Detail".localized(appLanguage))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            if hasChanges {
                                showDiscardConfirmation = true
                            } else {
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.gray.opacity(0.8))
                        .confirmationDialog("Discard Changes".localized(appLanguage), isPresented: $showDiscardConfirmation, titleVisibility: .visible) {
                            Button("Discard".localized(appLanguage), role: .destructive) {
                                dismiss()
                            }
                            Button("Keep Editing".localized(appLanguage), role: .cancel) {}
                        } message: {
                            Text("You have unsaved changes. Are you sure you want to discard them?".localized(appLanguage))
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            saveTask()
                        } label: {
                            Image(systemName: "checkmark")
                        }
                        .buttonStyle(.glassProminent)
                        .foregroundColor(.white)
                    }
                }
                .presentationDetents(taskToEdit == nil ? [.medium, .large] : [.large])
            }
        }
    }
    
    private func processImageForText(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest {
            request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("Error recognizing text: \(String(describing: error))")
                return
            }
            
            let recognizedStrings = observations.compactMap {
                observation in
                observation.topCandidates(1).first?.string
            }
            
            let scannedText = recognizedStrings.joined(separator: " ")
            
            DispatchQueue.main.async {
                if !scannedText.isEmpty {
                    self.desc = self.desc.isEmpty ? scannedText : self.desc + "\n" + scannedText
                }
            }
        }
        
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform OCR: \(error)")
            }
        }
    }
    
    private func saveTask(){
        if var task = taskToEdit {
            task.title = title
            task.desc = desc
            task.startDate = startDate
            task.endDate = endDate
            task.priority = matrix
            taskViewModel.updateTask(task)
        } else {
            let newTask = TaskEntity(title: title, desc: desc, startDate: startDate, endDate: endDate, priority: matrix, isDone: false)
            taskViewModel.addTask(newTask)
        }
        
        dismiss()
    }
    
    private func deleteTask() {
        if let task = taskToEdit {
            taskViewModel.deleteTask(id: task.id)
            dismiss()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    AddTaskView()
        .environment(DIContainer().taskViewModel)
}
