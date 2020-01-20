//
//  UIImage+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 12/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit


extension UIImageView {
    func loadImage(from urlString: String, resize: CGFloat?, placeHolder: UIImage) {
        guard let url = URL(string: urlString) else {
            self.image = placeHolder
            return
        }
        let cache = NSCache<NSString,UIImage>()
        
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        } else {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                guard let image = UIImage(data: data) else { return }
                
                if let resize = resize {
                    let resizedImage = image.resizeImage(resize, opaque: false)
                    cache.setObject(resizedImage, forKey: urlString as NSString)
                } else {
                    cache.setObject(image, forKey: urlString as NSString)
                }
                DispatchQueue.main.async { self.image = image }
            }
        }
        
    }
}

extension UIImage {
    static var cache = NSCache<NSString,UIImage>()
    
    static func loadImage(from urlString: String, resize: CGFloat?, completion: @escaping (Result<UIImage,Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }

        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(.success(cachedImage))
            return
        } else {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError()))
                    }
                    return
                }
                guard let image = UIImage(data: data) else { return }
                
                if let resize = resize {
                    let resizedImage = image.resizeImage(resize, opaque: false)
                    cache.setObject(resizedImage, forKey: urlString as NSString)
                } else {
                    cache.setObject(image, forKey: urlString as NSString)
                }
                
                DispatchQueue.main.async { completion(.success(image)) }
            }
        }
    }
}

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

