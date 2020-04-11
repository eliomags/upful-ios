//
//  ManualSearchFlow+Protocols.swift
//  Upful
//
//  Created by Yanik Simpson on 4/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

typealias ManualScreenerItemUpdatable = ManualScreenItemUpdaterDelegate & ManualScreenItemDeleterDelegate

protocol ManualScreenItemDeleterDelegate: class {
    func didDelete(at indexPath: IndexPath)
}
protocol ManualScreenItemUpdaterDelegate: class {
    func didUpdate(manualScreenItemViewModel: ManualScreenItemViewModel, at indexPath: IndexPath)
}
