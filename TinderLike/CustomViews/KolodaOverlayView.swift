//
//  KolodaOverlayView.swift
//
//  Created by Yaroslav Sharafutdinov on 9/7/17.
//  Copyright © 2017 Yaroslav Sharafutdinov. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "YesOverlay"
private let overlayLeftImageName = "SkipOverlay"

class KolodaOverlayView: OverlayView {
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        return imageView
    }()
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left?:
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right?:
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
        }
    }
}
