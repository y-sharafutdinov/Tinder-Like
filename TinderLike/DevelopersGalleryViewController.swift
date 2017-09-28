//
//  ViewController.swift
//
//  Created by Yaroslav Sharafutdinov on 9/7/17.
//  Copyright © 2017 Yaroslav Sharafutdinov. All rights reserved.
//

import UIKit
import Koloda

class DevelopersGalleryViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!

    @IBOutlet weak var skipButtonCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var okButtonCenterX: NSLayoutConstraint!
    
    lazy var developers : Array<Developer> = CoreDataSupport.sharedInstance.developers()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        let space = UIScreen.main.bounds.width / 3

        skipButtonCenterX.constant = space
        okButtonCenterX.constant = space
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func developerSelected(title: String?, subtitle: String?) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    //MARK: IBActions
    
    @IBAction func onCrossButtonPressed(_ sender: UIButton) {
        kolodaView.swipe(SwipeResultDirection.left)
    }
    
    @IBAction func onOkButtonPressed(_ sender: UIButton) {
        kolodaView.swipe(SwipeResultDirection.topRight)
    }
}

//MARK: KolodaViewDataSource

extension DevelopersGalleryViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return developers.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let developer = developers[index]
        return DevProfileCardView(title: developer.name, subtitle: developer.skill, imageName: developer.gender, index: index)
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("KolodaOverlayView", owner: self, options: nil)?[0] as? KolodaOverlayView
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
}

//MARK: KolodaViewDelegate

extension DevelopersGalleryViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        return true
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .topRight, .topLeft]
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let developer = developers[index]
        developerSelected(title: developer.name, subtitle: developer.skill)
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) { }
}

extension DevelopersGalleryViewController: DevProfileCardViewProtocol {
    func onInfoButtonPressed(infoButton: UIButton, developerIndex index: Int) {
        let developer = developers[index]
        developerSelected(title: developer.name, subtitle: developer.skill)
    }
}
