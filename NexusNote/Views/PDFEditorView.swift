//
//  PDFEditorView.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/20/25.
//

import SwiftUI
import PDFKit
import SwiftData

// PDFEditorView.swift
struct PDFEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel: PDFEditorViewModel
    
    init(pdfDocument: PDFDocument) {
        _viewModel = StateObject(wrappedValue: PDFEditorViewModel(
            pdfDocument: pdfDocument,
            modelContext: ModelContext(try! ModelContainer(for: DrawingModel.self))
        ))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.pdfDocument != nil {
                    PDFNavigationView(viewModel: viewModel)
                    PDFContainerView(viewModel: viewModel)
                        .onAppear {
                            viewModel.loadDrawingForCurrentPage()
                        }
                } else {
                    Text("PDF not found")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .inactive || newPhase == .background {
                    viewModel.saveCurrentDrawing()
                }
            }
            .onReceive(Timer.publish(every: 5, on: .main, in: .common).autoconnect()) { _ in
                viewModel.saveCurrentDrawing()
            }
        }
    }
}
