//
//  ViewController.swift
//  Facebook_Animation
//
//  Created by Bhagat  Singh on 29/09/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let padding: CGFloat = 8
    let iconHeight: CGFloat = 38
    let images = [UIImage(named: "blue_like"), UIImage(named: "cry_laugh"), UIImage(named: "cry"), UIImage(named: "red_heart"), UIImage(named: "surprised"), UIImage(named: "angry")]
    
    var lastView: UIImageView?
    
    @IBOutlet weak var gestureButton: UIButton!
    
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        return containerView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createContainerView()
        addLongPressGesture()
    }
    
    func createContainerView() {
        
        let arrangedSubviews = images.map({ (image) -> Void in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight/2
            imageView.isUserInteractionEnabled = true
            stackView.addArrangedSubview(imageView)
        })
        
        iconsContainerView.addSubview(stackView)
        
        let numIcons = CGFloat(arrangedSubviews.count)
        let width =  numIcons * iconHeight + (numIcons + 1) * padding
        
        iconsContainerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        iconsContainerView.layer.cornerRadius = iconsContainerView.frame.height / 2
    
        stackView.frame = iconsContainerView.frame
        
        var i: Int = 0
        for view in stackView.arrangedSubviews {
            view.tag = i
            i = i + 1
        }
    }

    func addLongPressGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler(recognizer:)))
        longPressRecognizer.minimumPressDuration = 0.2
        view.addGestureRecognizer(longPressRecognizer)
    }
    
    //MARK:- Long Press Gesture Selector
    @objc func longPressGestureHandler(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            handleGestureBegan(recognizer: recognizer)
        }
        else if recognizer.state == .changed {
            handleGestureChanged(recognizer: recognizer)
        }
        else if recognizer.state == .ended {
            handleGestureEnded(recognizer: recognizer)
        }
    }
    
    //MARK:- Gesture Began
    func handleGestureBegan(recognizer: UILongPressGestureRecognizer) {
        view.addSubview(iconsContainerView)
        
        let pressedLocation = recognizer.location(in: self.view)
        let centeredX = (view.frame.width - iconsContainerView.frame.width) / 2
        
        iconsContainerView.alpha = 0.0
        iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.iconsContainerView.alpha = 1.0
            self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconsContainerView.frame.height)
        })
    }
    
    //MARK:- Gesture Changed
    func handleGestureChanged(recognizer: UILongPressGestureRecognizer) {
        let pressedLocation = recognizer.location(in: self.iconsContainerView)
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconsContainerView.frame.height/2)
        let hitTestedView = iconsContainerView.hitTest(fixedYLocation, with: nil)
        
        if hitTestedView is UIImageView {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                let translateTransform = CGAffineTransform(translationX: 0, y: -50)
                let scaleTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)

                hitTestedView?.transform = translateTransform.concatenating(scaleTransform)
            })
        }
    }
    
    //MARK:- Gesture Ended
    func handleGestureEnded(recognizer: UILongPressGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
         
            let stackView = self.iconsContainerView.subviews.first
            stackView?.subviews.forEach({ (imageView) in
                imageView.transform = .identity
            })
            
            self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: 50)
            self.iconsContainerView.alpha = 0.0
            
        }, completion: { (_) in
            self.iconsContainerView.removeFromSuperview()
        })
    }
}

