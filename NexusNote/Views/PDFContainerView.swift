//
//  PDFContainerView.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/21/25.
//

import SwiftUI
import PDFKit

struct PDFContainerView: UIViewRepresentable {
    @ObservedObject var viewModel: PDFEditorViewModel
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        
        viewModel.pdfView.translatesAutoresizingMaskIntoConstraints = false
        viewModel.canvasView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(viewModel.pdfView)
        containerView.addSubview(viewModel.canvasView)
        
        NSLayoutConstraint.activate([
            viewModel.pdfView.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewModel.pdfView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewModel.pdfView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewModel.pdfView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            viewModel.canvasView.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewModel.canvasView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewModel.canvasView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewModel.canvasView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Handle updates if needed
    }
}
