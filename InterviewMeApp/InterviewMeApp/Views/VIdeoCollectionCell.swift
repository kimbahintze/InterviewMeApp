//
//  VIdeoCollectionCell.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/18/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import AVFoundation

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
        thumbnailImage.layer.cornerRadius = 10
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            break
        case .changed:
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.05
            animation.repeatCount = 3.0
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 2, y: self.center.y - 1))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 2, y: self.center.y + 1))
            self.layer.add(animation, forKey: "shake")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        case .ended:
            delegate?.deleteAlert(cell: self)
        case .possible:
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }
}
