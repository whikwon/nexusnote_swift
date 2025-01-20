//
//  DrawingStateManager.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/19/25.
//

import Foundation
import PencilKit
import SwiftData

class DrawingStateManager {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveDrawing(_ drawing: PKDrawing, forPage page: Int) throws {
        guard let drawingData = try? drawing.dataRepresentation() else {
            throw DrawingError.serializationFailed
        }
        
        let descriptor = FetchDescriptor<DrawingModel>(
            predicate: #Predicate<DrawingModel> { drawing in
                drawing.pageIndex == page
            }
        )
        
        if let existingDrawing = try? modelContext.fetch(descriptor).first {
            existingDrawing.drawingData = drawingData
            existingDrawing.timestamp = Date()
        } else {
            let drawing = DrawingModel(
                id: UUID().uuidString,
                drawingData: drawingData,
                pageIndex: page
            )
            modelContext.insert(drawing)
        }
        
        try modelContext.save()
    }
    
    func loadDrawing(forPage page: Int) -> PKDrawing? {
        let descriptor = FetchDescriptor<DrawingModel>(
            predicate: #Predicate<DrawingModel> { drawing in
                drawing.pageIndex == page
            }
        )
        
        guard let savedDrawing = try? modelContext.fetch(descriptor).first,
              let drawing = try? PKDrawing(data: savedDrawing.drawingData) else {
            return nil
        }
        
        return drawing
    }
}

enum DrawingError: Error {
    case serializationFailed
}
