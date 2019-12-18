//
//  MenuViewProtocols.swift
//  Upful
//
//  Created by Yanik Simpson on 9/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol MenuViewItemDelegate: class {
    var menuBarView: MenuBarView { get }
    
    func hideMenuBar()
    func presentMenuBar()
}

protocol MenuBarDisplayable: UIViewController {
    var delegate: MenuViewItemDelegate? { get set }
    var menubarTitle: String { get set }
}


