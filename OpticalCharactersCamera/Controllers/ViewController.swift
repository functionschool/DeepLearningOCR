//
//  ViewController.swift
//  OpticalCharactersCamera
//
//  Created by Dinh Thanh An on 1/27/18.
//  Copyright © 2018 Dinh Thanh An. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let coreVision = CoreVisonWrapper()
    private let mlModel = MLModelWraper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testImage = #imageLiteral(resourceName: "India")
        showTestPreprocessImage(image: testImage)
    }
    
    private func showTestPreprocessImage(image: UIImage) {
        coreVision.processImage(from: image) {[weak self] characterImageArray in
            var yValue: CGFloat = 20
            for w in characterImageArray {
                var xValue: CGFloat = 10
                print("================================")
                for ch in w {
                    print("--> prediction result: \(self?.mlModel.predict(image: ch) ?? "nothing")")
                    
                    let chImageView = UIImageView(image: ch)
                    chImageView.frame.origin = CGPoint(x: xValue,
                                                       y: yValue)
                    self?.view.addSubview(chImageView)
                    xValue += (chImageView.frame.size.width + 5)
                }
                yValue += 30
            }
        }
    }

    // Actions
    private func takePhotoTouched() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true) {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                
            }
        }
    }
}

