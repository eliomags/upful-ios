//
//  NotesEmptyCell.swift
//  Upful
//
//  Created by Yanik Simpson on 9/24/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class GeneralEmptyCell: UITableViewCell {
    
    var emptyImage: UIImage {
        return UIImage()
    }
    
    var emptyDescription: String {
        return String()
    }
    
    lazy var cellImageView: UIImageView = {
        let imageView = UIImageView(image: emptyImage)
        
        return imageView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    lazy var stackViewEmpty: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cellImageView, descriptionLabel])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


