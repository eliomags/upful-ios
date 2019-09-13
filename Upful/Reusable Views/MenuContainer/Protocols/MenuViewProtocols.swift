//
//  MenuViewProtocols.swift
//  Upful
//
//  Created by Yanik Simpson on 9/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


protocol MenuViewItemDelegate: class {
    func hideMenuBar()
    func presentMenuBar()
    func navigateTo(_ viewController: UIViewController)
    func presentViewController(_ viewController: UIViewController)
}

protocol MenuBarDisplayable: UITableViewController {
    var delegate: MenuViewItemDelegate? { get set }
    var menubarTitle: String { get set }
}
