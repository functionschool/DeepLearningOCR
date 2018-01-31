//
//  CoreVisionWrapper.swift
//  OCRCV
//
//  Created by Dinh Thanh An on 10/2/17.
//  Copyright © 2017 Hoang Cap. All rights reserved.
//

import Foundation
import Vision
import UIKit

class CoreVisonWrapper {
    private var requests = [VNRequest]()
    private var imageSize = CGSize.zero
    private var processedImageCompletion: (([Any]) -> Void)? = nil
    private var imageFixedOrientation: UIImage!
    
    init() {
        setupVision()
    }
    
    func processImage(from input: UIImage) {
        let requestOptions:[VNImageOption : Any] = [:]
        let imageRequestHandler = VNImageRequestHandler(cgImage: input.cgImage!, options: requestOptions)
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Vision Setup
    func setupVision() {
        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.textDetectionHandler)
        textRequest.reportCharacterBoxes = true
        
        self.requests = [textRequest]
    }
    
    func textDetectionHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results else {print("no result"); return}
        let result = observations.map({$0 as? VNTextObservation})
        var rectArray = [NSValue](), imageProcessedArray = [UIImage]()
        for region in result {
            guard let rg = region else {continue}
            let rect = getRegionBox(box: rg)
            if let boxes = rg.characterBoxes {
                for characterBox in boxes {
                    self.getTextBox(box: characterBox)
                }
            }
        }
        if let comletionClosure = processedImageCompletion {
            comletionClosure([imageFixedOrientation, imageProcessedArray, rectArray])
        }
    }
    
    // MARK: - Get region box
    func getRegionBox(box: VNTextObservation) -> CGRect {
        guard let boxes = box.characterBoxes else {return CGRect.zero}
        var xMin: CGFloat = 9999.0
        var xMax: CGFloat = 0.0
        var yMin: CGFloat = 9999.0
        var yMax: CGFloat = 0.0
        
        for char in boxes {
            if char.bottomLeft.x < xMin {xMin = char.bottomLeft.x}
            if char.bottomRight.x > xMax {xMax = char.bottomRight.x}
            if char.bottomRight.y < yMin {yMin = char.bottomRight.y}
            if char.topRight.y > yMax {yMax = char.topRight.y}
        }
        
        let margin: CGFloat = 5
        
        let xCoord = xMin * imageSize.width - margin / 2
        let yCoord = (1 - yMax) * imageSize.height  - margin / 2
        let width = (xMax - xMin) * imageSize.width + margin
        let height = (yMax - yMin) * imageSize.height + margin
        
        return CGRect(x: xCoord, y: yCoord, width: width, height: height)
    }
    
    func getTextBox(box: VNRectangleObservation) -> CGRect {
        let xCoord = box.topLeft.x * imageSize.width
        let yCoord = (1 - box.topLeft.y) * imageSize.height
        let width = (box.topRight.x - box.bottomLeft.x) * imageSize.width
        let height = (box.topLeft.y - box.bottomLeft.y) * imageSize.height
        
        return CGRect(x: xCoord, y: yCoord, width: width, height: height)
    }
    
    func processImage(from input: UIImage!, completionHandler completion: (([Any]?) -> Void)!) {
        processedImageCompletion = completion
        imageSize = input.size
        processImage(from: input)
    }
}
