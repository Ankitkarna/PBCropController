//
//  Extensions.swift
//  CropApp
//
//  Created by Ankit Karna on 4/15/20.
//  Copyright © 2020 Ankit Karna. All rights reserved.
//

import UIKit

enum ImageOrientation {
    case landscape
    case portrait
    case squared
}

extension UIImage {
    
    func getImageOrientation() -> ImageOrientation {
        if size.width > size.height {
            return .landscape
        } else if size.height > size.width {
            return .portrait
        } else {
            return .squared
        }
    }
}
