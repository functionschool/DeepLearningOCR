//
//  MLModelWrapper.swift
//  OpticalCharactersCamera
//
//  Created by Dinh Thanh An on 1/27/18.
//  Copyright © 2018 Dinh Thanh An. All rights reserved.
//

import CoreML
import UIKit

struct MLModelWraper {
    private static let trainedImageSize = CGSize(width: 64, height: 64)
    private static let resultArray = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
    
    // Predict
    static func predict(image: UIImage) -> String {
        do {
            if let resizedImage = Util.resize(image: image, newSize: trainedImageSize),
                let pixelBuffer = resizedImage.toCVPixelBuffer() {
                let model = NumberChactersRecognitionModel()
                let prediction = try model.prediction(data: pixelBuffer)
                for i in 0..<prediction.output1.count {
                    if prediction.output1[i] == 1 {
                        return "\(resultArray[i])"
                    }
                }
            }
        } catch {
            print("Error while doing predictions: \(error)")
        }
        
        return ""
    }
}
