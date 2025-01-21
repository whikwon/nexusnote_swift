//
//  FileListViewModel.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/20/25.
//

import SwiftUI
import PDFKit

@MainActor
class FileListViewModel: ObservableObject {
    @Published var files: [PDFFile] = []
    @Published var selectedFile: PDFFile?
    
    func loadFiles() {
        var pdfFiles: [PDFFile] = []
        
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let fileURLs = try! FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
                
                let pdfURLs = fileURLs
                    .filter { $0.pathExtension.lowercased() == "pdf" }
                    .map { PDFFile(name: $0.lastPathComponent, url: $0) }
                
                pdfFiles.append(contentsOf: pdfURLs)
            } catch {
                print("Error loading PDF files from documents: \(error)")
            }
        }
        
        files = pdfFiles
    }
    
    func addFile(_ url: URL) {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                // Create destination URL in documents directory
                let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
                try FileManager.default.copyItem(at: url, to: destinationURL)
                let newFile = PDFFile(name: url.lastPathComponent, url: destinationURL)
                files.append(newFile)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
