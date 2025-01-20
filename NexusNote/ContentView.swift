import SwiftUI
import PDFKit
import SwiftData
import PencilKit

// First, let's modify the DrawingData model to include page information
struct ContentView: View {
    var body: some View {
        FileListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: DrawingModel.self, inMemory: true, isAutosaveEnabled: false)
}
