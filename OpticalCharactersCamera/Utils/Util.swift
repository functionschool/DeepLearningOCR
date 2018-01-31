//
//  Util.swift
//  OpticalCharactersCamera
//
//  Created by Dinh Thanh An on 1/27/18.
//  Copyright © 2018 Dinh Thanh An. All rights reserved.
//

import UIKit

struct Util {
    static func resize(image: UIImage, newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
