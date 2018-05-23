//
//  VIdeoCollectionCell.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/18/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

protocol VideoCellDelegate: class {
    func deleteAlert(cell: VideoCollectionCell)
}

class VideoCollectionCell: UICollectionViewCell {
    
    weak var delegate: VideoCellDelegate?
    
    let thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        self.addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        contentView.addSubview(thumbnailImage)
        
        thumbnailImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        thumbnailImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        thumbnailImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        thumbnailImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        thumbnailImage.layer.cornerRadius = 20.0
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state != .ended {
            delegate?.deleteAlert(cell: self)
        }
    }
}
