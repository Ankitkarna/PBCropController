//
//  CropViewModel.swift
//  CropApp
//
//  Created by Ankit Karna on 4/22/20.
//  Copyright © 2020 Ankit Karna. All rights reserved.
//

import UIKit

class CropViewModel {
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewSize: CGSize) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewSize.width,
                                 inputImage.size.height / viewSize.height)

        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale,
                              height:cropRect.size.height * imageViewScale)

        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
        else {
            return nil
        }

        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
}
