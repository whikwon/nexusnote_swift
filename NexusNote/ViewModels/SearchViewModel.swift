//
//  SearchViewModel.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/20/25.
//

//import PDFKit
//
//@MainActor
//class SearchViewModel: ObservableObject {
//    @Published var searchText = ""
//    @Published private(set) var searchResults: [PDFSelection] = []
//    @Published private(set) var currentSearchIndex = 0
//    @Published var isSearching = false
//    
//    func performSearch() {
//        guard !searchText.isEmpty else {
//            searchResults = []
//            isSearching = false
//            return
//        }
//        
//        isSearching = true
//        searchResults = pdfService.performSearch(searchText)
//        if !searchResults.isEmpty {
//            highlightCurrentResult()
//        }
//    }
//    
//    func nextResult() {
//        guard !searchResults.isEmpty else { return }
//        currentSearchIndex = (currentSearchIndex + 1) % searchResults.count
//        highlightCurrentResult()
//    }
//    
//    func previousResult() {
//        guard !searchResults.isEmpty else { return }
//        currentSearchIndex = currentSearchIndex == 0 ? searchResults.count - 1 : currentSearchIndex - 1
//        highlightCurrentResult()
//    }
//    
//    private func highlightCurrentResult() {
//        let selection = searchResults[currentSearchIndex]
//        selection.color = .yellow
//        pdfService.goToSelection(selection)
//    }
//    
//    
//}
