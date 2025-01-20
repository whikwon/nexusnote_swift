//
//  PDFNavigationViewModel.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/19/25.
//

import SwiftUI
import PDFKit
import PencilKit
import SwiftData

@MainActor
class PDFDrawingViewModel: ObservableObject {
    @Published var pdfDocument: PDFDocument?
    @Published var currentPage = 0
    @Published var totalPages = 0
    
    private let drawingManager: DrawingStateManager
    
    init(pdfDocument: PDFDocument?, modelContext: ModelContext) {
        self.pdfDocument = pdfDocument
        self.drawingManager = DrawingStateManager(modelContext: modelContext)
        
        if let pdfDocument = pdfDocument {
            totalPages = pdfDocument.pageCount
        }
    }
    
    func moveToPage(_ page: Int, currentDrawing: PKDrawing) -> PDFPage? {
        guard let targetPage = pdfDocument?.page(at: page),
              page >= 0 && page < totalPages else { return nil }
        
        saveDrawing(currentDrawing)
        currentPage = page
        return targetPage
    }
    
    func previousPage(currentDrawing: PKDrawing) -> PDFPage? {
        moveToPage(currentPage - 1, currentDrawing: currentDrawing)
    }
    
    func nextPage(currentDrawing: PKDrawing) -> PDFPage? {
        moveToPage(currentPage + 1, currentDrawing: currentDrawing)
    }
    
    func saveDrawing(_ drawing: PKDrawing) {
        try? drawingManager.saveDrawing(drawing, forPage: currentPage)
    }
    
    func loadDrawing() -> PKDrawing {
        drawingManager.loadDrawing(forPage: currentPage) ?? PKDrawing()
    }
    
    func setDocument(_ pdfDocument: PDFDocument?) {
        self.pdfDocument = pdfDocument
        currentPage = 0
        if let pdfDocument = pdfDocument {
            totalPages = pdfDocument.pageCount
        } else {
            totalPages = 0
        }
    }
}
