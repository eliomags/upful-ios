//
//  ScreenerSelectionDelegate.swift
//  Upful
//
//  Created by Yanik Simpson on 1/5/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

protocol ScreenerSelectionDelegate: UIViewController {
    func didSelectScreener(searchParameters: [String])
}
