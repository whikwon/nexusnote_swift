//
//  PDFDrawingView.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/19/25.
//

import SwiftUI
import UIKit
import PDFKit
import PencilKit

import SwiftUI
import PDFKit
import PencilKit

struct PDFDrawingView: UIViewRepresentable {
    @ObservedObject var viewModel: PDFDrawingViewModel
    let coordinator: PDFDrawingCoordinator
    
    init(viewModel: PDFDrawingViewModel, coordinator: PDFDrawingCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    func makeCoordinator() -> PDFDrawingCoordinator {
        coordinator
    }
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        let coordinator = context.coordinator
        
        coordinator.pdfView.translatesAutoresizingMaskIntoConstraints = false
        coordinator.canvasView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(coordinator.pdfView)
        containerView.addSubview(coordinator.canvasView)
        
        NSLayoutConstraint.activate([
            coordinator.pdfView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coordinator.pdfView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coordinator.pdfView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coordinator.pdfView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            coordinator.canvasView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coordinator.canvasView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coordinator.canvasView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coordinator.canvasView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Handle updates if needed
    }
}

class PDFDrawingCoordinator: NSObject {
    var pdfView: PDFView
    var canvasView: PKCanvasView
    var toolPicker: PKToolPicker
    
    init(pdfDocument: PDFDocument?) {
        self.pdfView = PDFView()
        self.canvasView = PKCanvasView()
        self.toolPicker = PKToolPicker()
        
        super.init()
        
        setupPDFView(with: pdfDocument)
        setupCanvasView()
        setupToolPicker()
    }
    
    private func setupPDFView(with document: PDFDocument?) {
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
    }
    
    private func setupCanvasView() {
        canvasView.backgroundColor = .clear
    }
    
    private func setupToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
}
