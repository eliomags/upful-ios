//
//  UIImage+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 12/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage

        let size = self.size
        let aspectRatio =  size.width/size.height

        switch contentMode {
            case .scaleAspectFit:
                if aspectRatio > 1 {                            // Landscape image
                    width = dimension
                    height = dimension / aspectRatio
                } else {                                        // Portrait image
                    height = dimension
                    width = dimension * aspectRatio
                }
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    
        return newImage
    }
}

