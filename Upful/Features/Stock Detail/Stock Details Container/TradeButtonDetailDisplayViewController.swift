//
//  TradeButtonDetailDisplayViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 3/27/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class TradeButtonDetailPresenter {
    private let sourceView: UIView
    private let userDefaults: UserDefaults
    private let presentingViewController: PresentationDelegateViewController

    private struct Constants {
        static let didShowTradeButtonHintView = "didShowTradeButtonHintView"
    }

    lazy var didShowTradeButtonHintView: Bool = {
        return userDefaults.bool(forKey: Constants.didShowTradeButtonHintView)
    }()
    
    typealias PresentationDelegateViewController = UIPopoverPresentationControllerDelegate & UIViewController
    init(sourceView: UIView,
         userDefaults: UserDefaults = UserDefaults.standard,
         presentingViewController: PresentationDelegateViewController) {
        self.sourceView = sourceView
        self.userDefaults = userDefaults
        self.presentingViewController = presentingViewController
    }
    
    func present() {
        if !didShowTradeButtonHintView {
            let popoverContentController = TradeButtonDetailDisplayViewController()
            popoverContentController.modalPresentationStyle = .popover
                 
            if let popoverPresentationController = popoverContentController.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = .down
                popoverPresentationController.sourceView = sourceView
                popoverPresentationController.sourceRect = sourceView.frame
                popoverPresentationController.delegate = presentingViewController
                
                presentingViewController.present(popoverContentController, animated: true, completion: {
                    self.userDefaults.set(true, forKey: Constants.didShowTradeButtonHintView)
                })
            }
        }
    }
}

final class TradeButtonDetailDisplayViewController: UIViewController {
    private let detailLabel: UILabel = {
        let label = UILabel()
        let size = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Tap to start trading any stock!"
        return label
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .appAccent2
        view.addSubview(detailLabel)
        detailLabel.fillSuperview(padding: .init(top: 0, left: 12, bottom: 12, right: 12))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.preferredContentSize = CGSize(width: 315, height: 56)
        view.addSubview(contentView)
        contentView.fillSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
