//
//  ViewSuggestionsVCTest.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 11/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful


class ViewSuggestionsVCTest: XCTestCase {

    var sut: ViewSuggestionsVC!
    
    override func setUp() {
        super.setUp()
        sut = ViewSuggestionsVC()
        sut.suggestionDataLoader = MockSuggestionLoader()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test State
    
    func test_initialState() {
        XCTAssertEqual(sut.state, ViewSuggestionsVC.State.pending)
    }
    
//    func test_loadingState() {
//        sut.viewDidLoad()
//        XCTAssertEqual(sut.state, ViewSuggestionsVC.State.loading)
//    }
    
    func test_loadedState() {
        sut.viewDidLoad()
        XCTAssertEqual(sut.state, ViewSuggestionsVC.State.loaded)
    }
    
    // MARK: - Test Functions
    
    func test_suggestionSetup() {
        sut.viewDidLoad()

        XCTAssertEqual(sut.suggestions.count, 2)
    }
    
    func test_suggestionIncrementFirstSuggestion() {
        sut.viewDidLoad()

        let indexPath = IndexPath(row: 0, section: 0)
        let firstSuggestion = sut.suggestions[0]
        
        sut.incrementSuggestion(indexPath: indexPath)
        sut.incrementSuggestion(indexPath: indexPath)

        XCTAssertEqual(firstSuggestion.votes, 2)
    }

}

class MockSuggestionLoader: SuggestionsLoaderProtocol {
    func updateVote(document: String) {
        
    }
    
    func commitVotes() {
        
    }
    
    func load(completion: @escaping SuggestionLoaderCompletion) {
        completion(Result {
            return [
                Suggestion(title: "Title 1", description: "Description 1", votes: 0),
                Suggestion(title: "Title 2", description: "Description 2", votes: 0)
            ]
        })
    }
}
