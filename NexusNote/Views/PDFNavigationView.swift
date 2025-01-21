//
//  PDFNavigationView.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/19/25.
//

import SwiftUI
import PDFKit

struct PDFNavigationView: View {
    @ObservedObject var viewModel: PDFEditorViewModel
    @State private var isOutlinePresented = false
    
    var body: some View {
        HStack {
            // Outline Button
            Button(action: {
                isOutlinePresented.toggle()
            }) {
                Image(systemName: "list.bullet")
                    .imageScale(.large)
            }
            .sheet(isPresented: $isOutlinePresented, onDismiss: {
                viewModel.canvasView.becomeFirstResponder()
                viewModel.toolPicker.setVisible(true, forFirstResponder: viewModel.canvasView)
            }) {
                NavigationView {
                    PDFOutlineView(
                        outline: viewModel.pdfView.document?.outlineRoot,
                        viewModel: viewModel
                    )
                    .navigationTitle("Table of Contents")
                }
            }
            
            Spacer()
            
            // Page Navigation
            Button(action: {
                if let newPage = viewModel.previousPage() {
                    viewModel.pdfView.go(to: newPage)
                }
            }) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
            }
            .disabled(viewModel.currentPage == 0)
            
            Text("Page \(viewModel.currentPage + 1) of \(viewModel.totalPages)")
                .font(.headline)
            
            Button(action: {
                if let newPage = viewModel.nextPage() {
                    viewModel.pdfView.go(to: newPage)
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
