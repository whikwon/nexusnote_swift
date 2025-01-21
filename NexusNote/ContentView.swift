import SwiftUI
import PDFKit
import SwiftData
import PencilKit

// First, let's modify the DrawingData model to include page information
struct ContentView: View {
    @StateObject private var fileListViewModel: FileListViewModel
    
    init() {
        _fileListViewModel = StateObject(wrappedValue: FileListViewModel())
    }
    
    var body: some View {
        FileListView(viewModel: fileListViewModel)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: DrawingModel.self, inMemory: true, isAutosaveEnabled: false)
}
