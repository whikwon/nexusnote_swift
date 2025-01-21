//
//  FileListView.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/20/25.
//

import SwiftUI
import PDFKit

// File List View
struct FileListView: View {
    @State private var selectedFile: PDFFile?
    @State private var showingFilePicker = false  // Add this
    @State private var isFileOpen = false
    @ObservedObject var viewModel: FileListViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.files) { file in
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
                        viewModel.addFile(url)
                    }
                case .failure(let error):
                    print("Error selecting file: \(error.localizedDescription)")
                }
            }
            .onAppear {
                viewModel.loadFiles()
            }
        }
    }
}
