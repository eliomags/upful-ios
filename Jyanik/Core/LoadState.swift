//
//  LoadState.swift
//  Jyanik
//
//  Shared loading state enum used across ViewModels
//

import Foundation

enum LoadState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}
