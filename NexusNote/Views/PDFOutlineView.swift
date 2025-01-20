//
//  PDFOutlineView.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/19/25.
//

import SwiftUI
import PDFKit

// PDFOutlineView.swift
import SwiftUI
import PDFKit

struct PDFOutlineView: View {
    @ObservedObject var viewModel: PDFDrawingViewModel
    let coordinator: PDFDrawingCoordinator
    @State private var isOutlinePresented = false
    
    var body: some View {
        HStack {
            // Add outline button to existing navigation
            Button(action: {
                isOutlinePresented.toggle()
            }) {
                Image(systemName: "list.bullet")
                    .imageScale(.large)
            }
            .sheet(isPresented: $isOutlinePresented, onDismiss: {
                // Restore tool picker visibility when sheet is dismissed
                coordinator.canvasView.becomeFirstResponder()
                coordinator.toolPicker.setVisible(true, forFirstResponder: coordinator.canvasView)
            }) {
                NavigationView {
                    OutlineListView(
                        outline: coordinator.pdfView.document?.outlineRoot,
                        coordinator: coordinator,
                        viewModel: viewModel
                    )
                    .navigationTitle("Table of Contents")
                }
            }
            
            Spacer()
        }
    }
}

struct OutlineListView: View {
    let outline: PDFOutline?
    let coordinator: PDFDrawingCoordinator
    @ObservedObject var viewModel: PDFDrawingViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if let outline = outline {
            List {
                ForEach(0..<outline.numberOfChildren, id: \.self) { index in
                    if let child = outline.child(at: index) {
                        OutlineItemView(
                            outline: child,
                            coordinator: coordinator,
                            viewModel: viewModel,
                            dismiss: dismiss
                        )
                    }
                }
            }
        } else {
            Text("No outline available")
                .foregroundColor(.secondary)
        }
    }
}

struct OutlineItemView: View {
    let outline: PDFOutline
    let coordinator: PDFDrawingCoordinator
    @ObservedObject var viewModel: PDFDrawingViewModel
    let dismiss: DismissAction
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if outline.numberOfChildren > 0 {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .onTapGesture {
                            isExpanded.toggle()
                        }
                }
                
                Text(outline.label ?? "Untitled")
                    .onTapGesture {
                        navigateToDestination()
                    }
            }
            
            if isExpanded {
                ForEach(0..<outline.numberOfChildren, id: \.self) { index in
                    if let child = outline.child(at: index) {
                        OutlineItemView(
                            outline: child,
                            coordinator: coordinator,
                            viewModel: viewModel,
                            dismiss: dismiss
                        )
                        .padding(.leading)
                    }
                }
            }
        }
    }
    
    private func navigateToDestination() {
        if let destination = outline.destination,
           let targetPage = destination.page,
           let pageIndex = coordinator.pdfView.document?.index(for: targetPage) {
            
            if let newPage = viewModel.moveToPage(pageIndex, currentDrawing: coordinator.canvasView.drawing) {
                coordinator.pdfView.go(to: newPage)
                coordinator.canvasView.drawing = viewModel.loadDrawing()
                dismiss()
                
                // Ensure tool picker remains visible after navigation
                DispatchQueue.main.async {
                    coordinator.canvasView.becomeFirstResponder()
                    coordinator.toolPicker.setVisible(true, forFirstResponder: coordinator.canvasView)
                }
            }
        }
    }
}
