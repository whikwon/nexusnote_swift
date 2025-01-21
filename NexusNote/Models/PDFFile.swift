//
//  PDFFile.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/20/25.
//

import Foundation

// First, let's create a model for our PDF files
struct PDFFile: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
}
