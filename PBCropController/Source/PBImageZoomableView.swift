//
//  PBImageZoomableView.swift
//  CropApp
//
//  Created by Ankit Karna on 4/14/20.
//  Copyright © 2020 Ankit Karna. All rights reserved.
//

import UIKit

protocol ZoomableImageDelegate: AnyObject {
    func shouldAllowImageViewPanning(by point: CGPoint) -> Bool
}

public class PBImageZoomableView: UIScrollView {
    private let image: UIImage
    private lazy var imageScale: CGFloat = calculateImageScale()
    
    weak var zoomableViewDelegate: ZoomableImageDelegate?
    let imageInsetMultiplier: CGFloat = 1.1
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        return imageView
    }()
    
    init(image: UIImage) {
        self.image = image
        super.init(frame: .zero)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func setupUI() {
        addSubview(photoImageView)
        photoImageView.image = image
        
        backgroundColor = .black
        maximumZoomScale = 6.0
        minimumZoomScale = 1
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        isScrollEnabled = true
        clipsToBounds = true
        contentInsetAdjustmentBehavior = .never
    }
    
    private func setupFrameForImageView(cropAreaRect: CGRect, cropRatio: CGFloat) {
        //reset previous zoom scale if any
        minimumZoomScale = 1.0
        zoomScale = 1.0
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let aspectRatio = imageHeight/imageWidth

        let cropAreaSize = cropAreaRect.size
        let imageViewWidth: CGFloat
        let imageViewHeight: CGFloat
    
        if cropRatio >= 1 {
            let minimumHeight = cropAreaSize.height * imageInsetMultiplier
            imageViewWidth = (minimumHeight / aspectRatio) * cropRatio
            imageViewHeight = minimumHeight * cropRatio
        } else {
            let minimumWidth = cropAreaSize.width * imageInsetMultiplier
            imageViewWidth = minimumWidth / cropRatio
            imageViewHeight = (minimumWidth * aspectRatio) / cropRatio
        }
        
        photoImageView.frame.size = CGSize(width: imageViewWidth, height: imageViewHeight)
       
        contentSize = photoImageView.frame.size
    }
    
    private func getImageViewOffset(from rect: CGRect) -> CGPoint {
        let imageViewSize = photoImageView.frame.size
        let boundSize = rect.size
        let imageViewXPos = (boundSize.width - imageViewSize.width)/2
        let imageViewYPos = (boundSize.height - imageViewSize.height)/2
        
        return CGPoint(x: imageViewXPos, y: imageViewYPos)
    }
    
    func setupCropAreaView(cropAreaRect: CGRect, cropRatio: CGFloat) {
        setupFrameForImageView(cropAreaRect: cropAreaRect, cropRatio: cropRatio)
        contentInset = UIEdgeInsets(top: cropAreaRect.minY, left: cropAreaRect.minX, bottom: bounds.maxY - cropAreaRect.maxY, right: bounds.maxX - cropAreaRect.maxX)
        
        let offset = getImageViewOffset(from: cropAreaRect)
        var xOffset: CGFloat = 0
        var yOffset: CGFloat  = 0
        if offset.x < 0 && offset.x < abs(cropAreaRect.minX) {
             xOffset = -(cropAreaRect.minX + offset.x)
        }
        
        if offset.y < 0 && offset.y < abs(cropAreaRect.minY) {
             yOffset = -(cropAreaRect.minY + offset.y)
        }
        contentOffset = CGPoint(x: xOffset, y: yOffset)
    }
    
    private func calculateImageScale() -> CGFloat {
        let orientation = image.getImageOrientation()
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        switch orientation {
        case .landscape:
            return imageWidth/imageHeight
        case .portrait:
            return imageHeight/imageWidth
        case .squared:
            return 1
        }
    }
}

extension PBImageZoomableView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}
