//
//  DrawingModel.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/19/25.
//

import SwiftData
import SwiftUI

@Model
class DrawingModel {
    var id: String
    var drawingData: Data
    var pageIndex: Int  // Add page index
    var timestamp: Date
    
    init(id: String, drawingData: Data, pageIndex: Int) {
        self.id = id
        self.drawingData = drawingData
        self.pageIndex = pageIndex
        self.timestamp = Date()
    }
}
