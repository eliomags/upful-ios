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
        sut.viewDidLoad()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_suggestionSetup() {
        XCTAssertEqual(sut.suggestions.count, 2)
    }
    
    func test_suggestionIncrementFirstSuggestion() {
        let indexPath = IndexPath(row: 0, section: 0)
        let firstSuggestion = sut.suggestions[0]
        
        sut.incrementSuggestion(indexPath: indexPath)
        sut.incrementSuggestion(indexPath: indexPath)

        XCTAssertEqual(firstSuggestion.votes, 2)
    }

}

class MockSuggestionLoader: SuggestionsLoaderProtocol {
    func load(completion: @escaping SuggestionLoaderCompletion) {
        completion(Result {
            return [
                Suggestion(title: "Title 1", description: "Description 1", votes: 0),
                Suggestion(title: "Title 2", description: "Description 2", votes: 0)
            ]
        })
    }
}
