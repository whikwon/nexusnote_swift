//
//  PDFNavigationView.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/19/25.
//

import SwiftUI
import PDFKit

struct PDFNavigationView: View {
    @ObservedObject var viewModel: PDFDrawingViewModel
    let coordinator: PDFDrawingCoordinator
    
    var body: some View {
        HStack {
            PDFOutlineView(viewModel: viewModel, coordinator: coordinator)
            
            Button(action: {
                if let newPage = viewModel.previousPage(currentDrawing: coordinator.canvasView.drawing) {
                    coordinator.pdfView.go(to: newPage)
                    coordinator.canvasView.drawing = viewModel.loadDrawing()
                }
            }) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
            }
            .disabled(viewModel.currentPage == 0)
            
            Text("Page \(viewModel.currentPage + 1) of \(viewModel.totalPages)")
                .font(.headline)
            
            Button(action: {
                if let newPage = viewModel.nextPage(currentDrawing: coordinator.canvasView.drawing) {
                    coordinator.pdfView.go(to: newPage)
                    coordinator.canvasView.drawing = viewModel.loadDrawing()
                }
            }) {
                Image(systemName: "chevron.right")
                    .imageScale(.large)
            }
            .disabled(viewModel.currentPage == viewModel.totalPages - 1)
        }
        .padding()
    }
}
