//
//  SuggestionLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 11/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

protocol SuggestionsLoaderProtocol {
    typealias SuggestionLoaderCompletion = (Result<[Suggestion],Error>) -> Void
    func load(completion: @escaping SuggestionLoaderCompletion)
}

class SuggestionDataLoader: SuggestionsLoaderProtocol {
    typealias SuggestionLoaderCompletion = (Result<[Suggestion],Error>) -> Void

    private let backendService: FirestoreAPI = FirestoreAPI()
    
    func load(completion: @escaping SuggestionLoaderCompletion) {
        backendService.fetch(from: .suggestions) { (result) in
            switch result {
            case .success(let suggestionsDocs):
                if let suggestionsDocs = suggestionsDocs as? [[String: Any]] {
                    var suggestions = [Suggestion]()
                    
                    suggestionsDocs.forEach { (dictionary) in
                        suggestions.append(Suggestion(dictionary: dictionary))
                    }
                    completion(.success(suggestions))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
