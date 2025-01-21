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

// PDFOutlineView.swift
struct PDFOutlineView: View {
    let outline: PDFOutline?
    @ObservedObject var viewModel: PDFEditorViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if let outline = outline {
            List {
                ForEach(0..<outline.numberOfChildren, id: \.self) { index in
                    if let child = outline.child(at: index) {
                        OutlineItemView(
                            outline: child,
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
    @ObservedObject var viewModel: PDFEditorViewModel
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
           let pageIndex = viewModel.pdfView.document?.index(for: targetPage) {
            
            if let newPage = viewModel.moveToPage(pageIndex) {
                viewModel.pdfView.go(to: newPage)
                dismiss()
                
                // Ensure tool picker remains visible after navigation
                DispatchQueue.main.async {
                    viewModel.canvasView.becomeFirstResponder()
                    viewModel.toolPicker.setVisible(true, forFirstResponder: viewModel.canvasView)
                }
            }
        }
    }
}
