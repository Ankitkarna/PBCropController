//
//  ImageCropView.swift
//  CropApp
//
//  Created by Ankit Karna on 4/15/20.
//  Copyright © 2020 Ankit Karna. All rights reserved.
//

import UIKit

class ImageCropView: UIView {
    private let image: UIImage
    
    private(set) var zoomableView: PBImageZoomableView!
    private(set) var cropAreaView: CropAreaView!
    private let cropType: CropType
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cropAreaView.layoutIfNeeded()
        let cropRectViewRect = cropAreaView.convert(cropAreaView.visibleView.frame, to: zoomableView)
        zoomableView.setupCropAreaView(cropAreaRect: cropRectViewRect, cropRatio: cropType.ratio)
    }
    
    init(image: UIImage, cropType: CropType) {
        self.image = image
        self.cropType = cropType
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        addZoomableView()
        addCropAreaView()
    }
    
    private func addZoomableView() {
        zoomableView = PBImageZoomableView(image: image)
        zoomableView.clipsToBounds = false
        clipsToBounds = true
        addSubview(zoomableView)
        zoomableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            zoomableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            zoomableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            zoomableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            zoomableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        
        zoomableView.zoomableViewDelegate = self
    }
    
    private func addCropAreaView() {
        cropAreaView = CropAreaView(cropType: cropType)
        addSubview(cropAreaView)
        cropAreaView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            cropAreaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cropAreaView.topAnchor.constraint(equalTo: topAnchor),
            cropAreaView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cropAreaView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ImageCropView: ZoomableImageDelegate {
    func shouldAllowImageViewPanning(by point: CGPoint) -> Bool {
        let photoImageFrame = zoomableView.photoImageView.frame
        let translation = CGAffineTransform(translationX: point.x, y: point.y)
        let newPhotoFrame = photoImageFrame.applying(translation)
        let newPhotoViewFrame = zoomableView
            
            .convert(newPhotoFrame, to: self)
        return isScrollPointInsideCropArea(imageViewRect: newPhotoViewFrame)
    }
    
    private func isScrollPointInsideCropArea(imageViewRect: CGRect) -> Bool {
        let cropAreaFrame = cropAreaView.convert(cropAreaView.visibleView.frame, to: self)
        return imageViewRect.contains(cropAreaFrame)
    }
}
