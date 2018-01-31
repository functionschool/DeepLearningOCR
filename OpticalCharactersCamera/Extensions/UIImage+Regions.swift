//
//  UIImage+Regions.swift
//  OpticalCharactersCamera
//
//  Created by Dinh Thanh An on 1/28/18.
//  Copyright © 2018 Dinh Thanh An. All rights reserved.
//

import UIKit

extension UIImage {
    func getImageRegion(with rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
        let imageRef = self.cgImage!.cropping(to: rect)!
        let regionImage = UIImage(cgImage: imageRef)
        UIGraphicsEndImageContext()
        
        return regionImage
    }
}
