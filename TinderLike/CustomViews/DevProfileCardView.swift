//
//  DevProfileCardView.swift
//
//  Created by Yaroslav Sharafutdinov on 9/7/17.
//  Copyright © 2017 Yaroslav Sharafutdinov. All rights reserved.
//

import UIKit
import QuartzCore

protocol DevProfileCardViewProtocol {
    func onInfoButtonPressed(infoButton: UIButton, developerIndex:Int)
}

class DevProfileCardView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var delegate : DevProfileCardViewProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        self.developerIndex = 0
        super.init(coder: aDecoder)
    }
    
    private func nibSetup() {
        let view = UINib(nibName: "DevProfileCardView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! DevProfileCardView
        
        view.frame = bounds
        self.addSubview(view);
    }
    
    private func setupUI() {
        
        nibSetup()
        
        layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        
        photoImageView.layer.cornerRadius = 10
        photoImageView.layer.masksToBounds = true
    }
    
    var developerIndex : Int
    
    init (title: String?, subtitle: String?, imageName: String?, index: Int) {
        
        developerIndex = index
        
        super.init(frame: CGRect.zero)
        
        setupUI()
        
        titleLabel.text = title
        subTitleLabel.text = subtitle
        
        if nil != imageName {
            photoImageView.image = UIImage(named: imageName!)
        }
    }
    
    //MARK: IBActions
    @IBAction func onInfoButtonPressed(_ sender: UIButton) {
        delegate?.onInfoButtonPressed(infoButton: sender, developerIndex: developerIndex)
    }
}
