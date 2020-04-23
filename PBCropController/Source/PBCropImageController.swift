//
//  PBCropImageController.swift
//  CropApp
//
//  Created by Ankit Karna on 4/15/20.
//  Copyright © 2020 Ankit Karna. All rights reserved.
//

import UIKit

public protocol PBCropImageDelegate: AnyObject {
    func didFinishCropping(outputImage: UIImage?)
}

public class PBCropImageController: UIViewController {

    public var image: UIImage!
    public let cropType: CropType
    
    private var cropView: ImageCropView!
    private let viewModel = CropViewModel()
    
    weak public var delegate: PBCropImageDelegate?
    
    public init(cropType: CropType) {
        self.cropType = cropType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    override public func loadView() {
        cropView = ImageCropView(image: image, cropType: cropType)
        view = cropView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func doneButtonTapped() {
        let imageViewFrame = cropView.zoomableView.convert(cropView.zoomableView.photoImageView.frame, to: cropView)
        let cropViewFrame = cropView.cropAreaView.convert(cropView.cropAreaView.visibleView.frame, to: cropView)
        let cropXPos = cropViewFrame.minX - imageViewFrame.minX
        let cropYPos = cropViewFrame.minY - imageViewFrame.minY
        let cropWidth = cropViewFrame.width
        let cropHeight = cropViewFrame.height
        let cropRect = CGRect(x: cropXPos, y: cropYPos, width: cropWidth, height: cropHeight)
        let croppedImage = viewModel.cropImage(image, toRect: cropRect, viewSize: imageViewFrame.size)
        
        delegate?.didFinishCropping(outputImage: croppedImage)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
