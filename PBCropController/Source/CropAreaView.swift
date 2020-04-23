//
//  CropAreaView.swift
//  CropApp
//
//  Created by Ankit Karna on 4/15/20.
//  Copyright © 2020 Ankit Karna. All rights reserved.
//

import UIKit

public enum CropType {
    case rectangle(aspectRatio: CGFloat)
    case circle
    
    var ratio: CGFloat {
        switch self {
        case .rectangle(aspectRatio: let ratio): return ratio
        case .circle: return 1
        }
    }
}

public class CropAreaView: UIView {
    private let cropType: CropType
    
    let visibleView = UIView()
    private let visibleLayer = CAShapeLayer()
    private let maskLayer = CAShapeLayer()
    
    private let visibleBorderWidth: CGFloat = 2
    var paddingMultiplier: CGFloat = 0.8
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let ratio = cropType.ratio
        let visibleViewRect = getVisibleRect(ratio: ratio, bounds: bounds, paddingMultipier: paddingMultiplier)
        visibleView.frame = visibleViewRect
        visibleLayer.path = getVisiblePath(bounds: visibleView.bounds, inset: visibleBorderWidth)?.cgPath
        visibleLayer.frame = visibleView.bounds
        
        maskLayer.frame = bounds
        if let visibleLayerPath = getVisiblePath(bounds: bounds, paddingMultiplier: paddingMultiplier, inset: visibleBorderWidth) {
            let maskPath = UIBezierPath(rect: bounds)
            maskPath.append(visibleLayerPath)
            maskLayer.path = maskPath.cgPath
        }
    }
    
    init(cropType: CropType) {
        self.cropType = cropType
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented.")
    }
    
    private func setupUI() {
        isUserInteractionEnabled = false
        setupVisibleView()
        setupMaskLayer()
    }
    
    private func setupVisibleView() {
        addSubview(visibleView)
        setupVisibleLayer()
    }
    
    private func setupVisibleLayer() {
        visibleLayer.fillColor = UIColor.clear.cgColor
        visibleView.layer.addSublayer(visibleLayer)
        visibleView.layer.borderColor = UIColor.blue.cgColor
        visibleView.layer.borderWidth = visibleBorderWidth
    }
    
    private func setupMaskLayer() {
        maskLayer.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor
        maskLayer.fillRule = .evenOdd
        layer.addSublayer(maskLayer)
    }
    
    private func getVisibleRect(ratio: CGFloat, bounds: CGRect, paddingMultipier: CGFloat = 1.0, inset: CGFloat = 0) -> CGRect {
        let maskWidth = bounds.width * paddingMultipier
        let maskHeight = maskWidth / ratio
        let xOrigin = max((bounds.width - maskWidth) / 2, 0)
        let yOrigin = max((bounds.height - maskHeight) / 2, 0)
        let rect = CGRect(x: xOrigin, y: yOrigin, width: maskWidth, height: maskHeight)
        let insetRect = rect.insetBy(dx: inset, dy: inset)
        return insetRect
    }
    
    private func getVisiblePath(bounds: CGRect, paddingMultiplier: CGFloat = 1.0, inset: CGFloat = 0) -> UIBezierPath? {
        switch cropType {
        case .rectangle(aspectRatio: let ratio): return getRectangleVisiblePath(ratio: ratio, bounds: bounds, paddingMultiplier: paddingMultiplier, inset: inset)
        case .circle: return getCircleVisiblePath(bounds: bounds, paddingMultiplier: paddingMultiplier, inset: inset)
        }
    }
    
    private func getRectangleVisiblePath(ratio: CGFloat, bounds: CGRect, paddingMultiplier: CGFloat, inset: CGFloat) -> UIBezierPath? {
        let rect = getVisibleRect(ratio: ratio, bounds: bounds, paddingMultipier: paddingMultiplier, inset: inset)
        let path = UIBezierPath(rect: rect)
        return path
    }
    
    private func getCircleVisiblePath(bounds: CGRect, paddingMultiplier: CGFloat, inset: CGFloat) -> UIBezierPath? {
        let squaredRect = getVisibleRect(ratio: 1, bounds: bounds, paddingMultipier: paddingMultiplier, inset: inset)
        let path = UIBezierPath(ovalIn: squaredRect)
        return path
    }
}
