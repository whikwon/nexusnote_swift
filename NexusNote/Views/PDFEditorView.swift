//
//  PDFEditorView.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/20/25.
//

import SwiftUI
import PDFKit
import SwiftData

struct PDFEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PDFDrawingViewModel
    private let coordinator: PDFDrawingCoordinator
    
    init(pdfDocument: PDFDocument) {
        _viewModel = StateObject(wrappedValue: PDFDrawingViewModel(
            pdfDocument: pdfDocument,
            modelContext: ModelContext(try! ModelContainer(for: DrawingModel.self))
        ))
        coordinator = PDFDrawingCoordinator(pdfDocument: pdfDocument)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if coordinator.pdfView.document != nil {
                    PDFNavigationView(viewModel: viewModel, coordinator: coordinator)
                    PDFDrawingView(viewModel: viewModel, coordinator: coordinator)
                        .onAppear {
                            coordinator.canvasView.drawing = viewModel.loadDrawing()
                        }
                } else {
                    Text("PDF not found")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .inactive || newPhase == .background {
                    viewModel.saveDrawing(coordinator.canvasView.drawing)
                }
            }
            .onReceive(Timer.publish(every: 5, on: .main, in: .common).autoconnect()) { _ in
                viewModel.saveDrawing(coordinator.canvasView.drawing)
            }
        }
    }
}
