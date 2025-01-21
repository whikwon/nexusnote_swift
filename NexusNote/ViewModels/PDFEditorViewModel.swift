//
//  PDFEditorViewModel.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/21/25.
//

import SwiftUI
import PDFKit
import PencilKit
import SwiftData

@MainActor
class PDFEditorViewModel: ObservableObject {
    // PDF State
    @Published private(set) var pdfDocument: PDFDocument?
    @Published private(set) var currentPage = 0
    @Published private(set) var totalPages = 0
    
    // View Components
    let pdfView: PDFView
    let canvasView: PKCanvasView
    let toolPicker: PKToolPicker
    
    // Drawing Management
    private let drawingManager: DrawingStateManager
    
    init(pdfDocument: PDFDocument?, modelContext: ModelContext) {
        self.pdfDocument = pdfDocument
        self.drawingManager = DrawingStateManager(modelContext: modelContext)
        
        // Initialize views
        self.pdfView = PDFView()
        self.canvasView = PKCanvasView()
        self.toolPicker = PKToolPicker()
        
        if let pdfDocument = pdfDocument {
            totalPages = pdfDocument.pageCount
        }
        
        setupViews()
    }
    
    private func setupViews() {
        // PDF View setup
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        
        // Canvas setup
        canvasView.backgroundColor = .clear
        
        // Tool picker setup
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
    
    // Navigation Methods
    func moveToPage(_ page: Int) -> PDFPage? {
        guard let targetPage = pdfDocument?.page(at: page),
              page >= 0 && page < totalPages else { return nil }
        
        saveCurrentDrawing()
        currentPage = page
        loadDrawingForCurrentPage()
        return targetPage
    }
    
    func previousPage() -> PDFPage? {
        moveToPage(currentPage - 1)
    }
    
    func nextPage() -> PDFPage? {
        moveToPage(currentPage + 1)
    }
    
    // Drawing Management
    func saveCurrentDrawing() {
        try? drawingManager.saveDrawing(canvasView.drawing, forPage: currentPage)
    }
    
    func loadDrawingForCurrentPage() {
        canvasView.drawing = drawingManager.loadDrawing(forPage: currentPage) ?? PKDrawing()
    }
}
