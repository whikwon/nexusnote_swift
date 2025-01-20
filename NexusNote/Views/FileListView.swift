//
//  FileListView.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/20/25.
//

import SwiftUI
import PDFKit

// First, let's create a model for our PDF files
struct PDFFile: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
}

// File List View
struct FileListView: View {
    @State private var files: [PDFFile] = []
    @State private var selectedFile: PDFFile?
    @State private var showingFilePicker = false  // Add this
    @State private var isFileOpen = false
    
    var body: some View {
        NavigationStack {
            List(files) { file in
                NavigationLink {
                    if let pdfDocument = PDFDocument(url: file.url) {
                        PDFEditorView(pdfDocument: pdfDocument)
                    }
                } label: {
                    HStack {
                        Image(systemName: "doc.fill")
                            .foregroundColor(.blue)
                        Text(file.name)
                    }
                }
            }
            .navigationTitle("PDF Files")
            .toolbar {
                Button {
                    showingFilePicker = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: true
            ) { result in
                // Handle selected files
                switch result {
                case .success(let urls):
                    for url in urls {
                        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                            do {
                                // Create destination URL in documents directory
                                let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
                                
                                // Copy the file to documents directory
                                try FileManager.default.copyItem(at: url, to: destinationURL)
                                
                                // Add to files array
                                let newFile = PDFFile(name: url.lastPathComponent, url: destinationURL)
                                files.append(newFile)
                            } catch {
                                print("Error copying file: \(error.localizedDescription)")
                            }
                        }
                    }
                case .failure(let error):
                    print("Error selecting file: \(error.localizedDescription)")
                }
            }
            .onAppear {
                loadPDFFiles()
            }
        }
    }

    private func loadPDFFiles() {
        var pdfFiles: [PDFFile] = []
        
        // Load bundled PDF files
//        let bundledPDFs = ["dinov2", "lorem"]
//        for pdfName in bundledPDFs {
//            if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
//                pdfFiles.append(PDFFile(name: "\(pdfName).pdf", url: url))
//            }
//        }
        
        // Load files from documents directory
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(
                    at: documentsPath,
                    includingPropertiesForKeys: nil,
                    options: [.skipsHiddenFiles]
                )
                
                let documentPDFs = fileURLs
                    .filter { $0.pathExtension.lowercased() == "pdf" }
                    .map { PDFFile(name: $0.lastPathComponent, url: $0) }
                
                pdfFiles.append(contentsOf: documentPDFs)
            } catch {
                print("Error loading PDF files from documents: \(error)")
            }
        }
        
        files = pdfFiles
    }
}

//struct FileListView: View {
//    @State private var files: [PDFFile] = []
//    @State private var selectedFile: PDFFile?
//    @State private var isFileOpen = false
//    @State private var showingFilePicker = false // Add this
//    
//    var body: some View {
//        NavigationStack {
//            List(files) { file in
//                NavigationLink {
//                    if let pdfDocument = PDFDocument(url: file.url) {
//                        PDFEditorView(pdfDocument: pdfDocument)
//                    }
//                } label: {
//                    HStack {
//                        Image(systemName: "doc.fill")
//                            .foregroundColor(.blue)
//                        Text(file.name)
//                    }
//                }
//            }
//            .navigationTitle("PDF Files")
//            .toolbar {
//                Button(action: {
//                    showingFilePicker = true
//                }) {
//                    Image(systemName: "plus")
//                }
//            }
//            .fileImporter(
//                isPresented: $showingFilePicker,
//                allowedContentTypes: [.pdf],
//                allowsMultipleSelection: true
//            ) { result in
//                handleSelectedFiles(result)
//            }
//            .onAppear {
//                loadPDFFiles()
//            }
//        }
//    }
//    
//    private func handleSelectedFiles(_ result: Result<[URL], Error>) {
//        do {
//            let selectedURLs = try result.get()
//            
//            for originalURL in selectedURLs {
//                // Start accessing security-scoped resource
//                guard originalURL.startAccessingSecurityScopedResource() else {
//                    continue
//                }
//                
//                defer {
//                    originalURL.stopAccessingSecurityScopedResource()
//                }
//                
//                // Create a unique filename to avoid conflicts
//                let uniqueFilename = UUID().uuidString + "_" + originalURL.lastPathComponent
//                
//                // Get the app's document directory
//                if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                    let destinationURL = documentsDirectory.appendingPathComponent(uniqueFilename)
//                    
//                    // Copy the file to our app's document directory
//                    try FileManager.default.copyItem(at: originalURL, to: destinationURL)
//                    
//                    // Add the new file to our files array
//                    let newPDFFile = PDFFile(name: originalURL.lastPathComponent, url: destinationURL)
//                    files.append(newPDFFile)
//                }
//            }
//        } catch {
//            print("Error importing files: \(error.localizedDescription)")
//        }
//    }
//}
