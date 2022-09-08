//
//  RatingView.swift
//  eventsProject
//
//  Created by Pietro Putelli on 23/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

open class RatingViewUser: UIView {
    
    private var emptyImageViews: [UIImageView] = []
    private var fullImageViews: [UIImageView] = []
    
    @IBInspectable open var emptyImage: UIImage? {
        
        didSet {
            
            for imageView in emptyImageViews {
                imageView.image = emptyImage
            }
            refresh()
        }
    }
    
    @IBInspectable open var fullImage: UIImage? {
        didSet {
            // Update full image views
            for imageView in fullImageViews {
                imageView.image = fullImage
            }
            refresh()
        }
    }
    
    var imageContentMode: UIViewContentMode = .scaleAspectFit
    
    var minRating: Int = 0 {
        didSet {
            // Update current rating if needed
            if rating < Double(minRating) {
                rating = Double(minRating)
                refresh()
            }
        }
    }
    
    var maxRating: Int = 5 {
        didSet {
            if maxRating != oldValue {
                removeImageViews()
                initImageViews()
                
                // Relayout and refresh
                setNeedsLayout()
                refresh()
            }
        }
    }
    
    var minImageSize: CGSize = CGSize(width: 4.0, height: 4.0)
    
    open var rating: Double = 0 {
        didSet {
            if rating != oldValue {
                refresh()
            }
        }
    }
    
    var editable: Bool = true
    
    // MARK: Type
    
    @objc public enum FloatRatingViewType: Int {
        case wholeRatings
    }
    
    /// Float rating view type
    var type: FloatRatingViewType = .wholeRatings
    
    // MARK: Initializations
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        
        initImageViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initImageViews()
    }
    
    // MARK: Helper methods
    
    private func initImageViews() {
        guard emptyImageViews.isEmpty && fullImageViews.isEmpty else {
            return
        }
        
        // Add new image views
        for _ in 0..<maxRating {
            let emptyImageView = UIImageView()
            emptyImageView.contentMode = imageContentMode
            emptyImageView.image = emptyImage
            emptyImageViews.append(emptyImageView)
            addSubview(emptyImageView)
            
            let fullImageView = UIImageView()
            fullImageView.contentMode = imageContentMode
            fullImageView.image = fullImage
            fullImageViews.append(fullImageView)
            addSubview(fullImageView)
        }
    }
    
    private func removeImageViews() {
        // Remove old image views
        for i in 0..<emptyImageViews.count {
            var imageView = emptyImageViews[i]
            imageView.removeFromSuperview()
            imageView = fullImageViews[i]
            imageView.removeFromSuperview()
        }
        emptyImageViews.removeAll(keepingCapacity: false)
        fullImageViews.removeAll(keepingCapacity: false)
    }
    
    // Refresh hides or shows full images
    private func refresh() {
        for i in 0..<fullImageViews.count {
            let imageView = fullImageViews[i]
            
            if rating >= Double(i + 1) {
                imageView.layer.mask = nil
                imageView.isHidden = false
            } else if rating > Double(i) && rating < Double(i + 1) {
                // Set mask layer for full image
                let maskLayer = CALayer()
                maskLayer.frame = CGRect(x: 0, y: 0, width: CGFloat(rating-Double(i)) * imageView.frame.size.width, height: imageView.frame.size.height)
                maskLayer.backgroundColor = UIColor.black.cgColor
                imageView.layer.mask = maskLayer
                imageView.isHidden = false
            } else {
                imageView.layer.mask = nil
                imageView.isHidden = true
            }
        }
    }
    
    // Calculates the ideal ImageView size in a given CGSize
    private func sizeForImage(_ image: UIImage, inSize size: CGSize) -> CGSize {
        let imageRatio = image.size.width / image.size.height
        let viewRatio = size.width / size.height
        
        if imageRatio < viewRatio {
            let scale = size.height / image.size.height
            let width = scale * image.size.width
            
            return CGSize(width: width, height: size.height)
        } else {
            let scale = size.width / image.size.width
            let height = scale * image.size.height
            
            return CGSize(width: size.width, height: height)
        }
    }
    
    func updateLocation(_ touch: UITouch) {
        
        guard editable else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        var newRating: Double = 0
        
        for i in stride(from: (maxRating - 1), through: 0, by: -1) {
            
            let imageView = emptyImageViews[i]
            
            guard touchLocation.x > imageView.frame.origin.x else {
                continue
            }
            
            newRating = Double(i) + 1.0
            
            break
        }
        rating = newRating < Double(minRating) ? Double(minRating) : newRating
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        guard let emptyImage = emptyImage else {
            return
        }
        
        let desiredImageWidth = frame.size.width / CGFloat(emptyImageViews.count)
        let maxImageWidth = max(minImageSize.width, desiredImageWidth)
        let maxImageHeight = max(minImageSize.height, frame.size.height)
        let imageViewSize = sizeForImage(emptyImage, inSize: CGSize(width: maxImageWidth, height: maxImageHeight))
        let imageXOffset = (frame.size.width - (imageViewSize.width * CGFloat(emptyImageViews.count))) /
            CGFloat((emptyImageViews.count - 1))
        
        for i in 0..<maxRating {
            let imageFrame = CGRect(x: CGFloat(i) * (imageXOffset + imageViewSize.width), y: 0, width: imageViewSize.width, height: imageViewSize.height)
            
            var imageView = emptyImageViews[i]
            imageView.frame = imageFrame
            
            imageView = fullImageViews[i]
            imageView.frame = imageFrame
        }
        
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        updateLocation(touch)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        updateLocation(touch)
    }
}
