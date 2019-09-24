//
//  CustomSizeImageView.swift
//  Upful
//
//  Created by Yanik Simpson on 9/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


class SmallImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 10, height: 10)
    }
}
