//
//  DragView.swift
//  Upful
//
//  Created by Yanik Simpson on 7/9/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

protocol DragViewDelegate: class {
    func dragViewDidEndScrolling(_ dragView: DragView, dragState: DragViewPresentationState)
}

class DragView: UIView {
    
    // MARK: Properties
    
    private(set) var controller: DragController!
    
    weak var delegate: (DragViewDelegate & UITableViewDelegate & UITableViewDataSource)?
    
    // MARK: View
    
    private let dragIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 6).isActive = true
        view.widthAnchor.constraint(equalToConstant: 44).isActive = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.delegate = delegate
        view.dataSource = delegate
        view.isScrollEnabled = false
        return view
    }()
    
    // MARK: Gestures
    
    private lazy var defaultPanGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDefaultPan))
        return gesture
    }()
    
    // MARK: Initializer
    
    init(configuration: DragStateConfiguration) {
        controller = DragController(configuration: configuration)
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: controller.configuration.partialHeight).isActive = true
        observePresentationStateChanges()
    }
    
    private func observePresentationStateChanges() {
        controller.presentationStateChangeHandler = { [unowned self] newState in
            self.defaultPanGesture.cancel()
            
            let heightForState: CGFloat
            switch self.controller.currentPresentationState {
            case .closed:
                heightForState = self.controller.configuration.closedHeight
                self.tableView.isScrollEnabled = false
                
            case .partial:
                heightForState = self.controller.configuration.partialHeight
                self.tableView.isScrollEnabled = false
                
            case .full:
                heightForState = self.controller.configuration.fullHeight
                self.tableView.isScrollEnabled = true
            }
            
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveLinear, animations: {
                self.constraints.first { $0.firstAnchor == self.heightAnchor }?.isActive = false
                self.heightAnchor.constraint(equalToConstant: heightForState).isActive = true
            }) { _ in
                self.delegate?.dragViewDidEndScrolling(self, dragState: newState)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: View Setup
    
    func setupView() {
        layer.cornerRadius = 16
        backgroundColor = .clear
        
        addGestureRecognizer(defaultPanGesture)
        
        addSubview(dragIndicator)
        dragIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dragIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: dragIndicator.bottomAnchor).isActive = true
    }
    
    // MARK: Methods
    
    private var startPosition = CGPoint()
    private var currentPosition = CGPoint()
    
    @objc private func handleDefaultPan(gesture: UIPanGestureRecognizer) {
        guard gesture.translation(in: self).y != 0 else { return }
        
        let swipeVelocity = -gesture.velocity(in: self).y
        
        if gesture.state == .began {
            startPosition = gesture.location(in: self)
        }
        
        if gesture.state == .began || gesture.state == .changed {
            currentPosition = gesture.location(in: self)
            
            if frame.height == controller.configuration.closedHeight && swipeVelocity < 0 {
                return
            }
            
            if frame.height == controller.configuration.fullHeight && swipeVelocity > 0 {
                return
            }
            
            //            controller.changeState(at: swipeVelocity)
            
            let difference = startPosition.y - currentPosition.y
            handleDragHeightUpdate(newHeight: frame.height + difference)
        }
        
        if gesture.state == .ended {
            controller.changeState(for: bounds.height)
        }
    }
    
    private func handleDragHeightUpdate(newHeight: CGFloat) {
        guard newHeight >= controller.configuration.closedHeight && newHeight <= controller.configuration.fullHeight else { return }
        self.constraints.first { $0.firstAnchor == self.heightAnchor }?.isActive = false
        UIView.animate(withDuration: 0) {
            self.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
        }
    }
}

extension UIPanGestureRecognizer {
    
    func cancel() {
        isEnabled = false
        isEnabled = true
    }
}

