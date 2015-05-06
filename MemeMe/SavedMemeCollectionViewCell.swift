//
//  SavedMemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 3/5/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class SavedMemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var meme: Meme? {
        didSet {
            if let meme = meme {
                cellImageView.image = meme.originalImage
                
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = cellImageView.bounds
                gradientLayer.colors = [
                    cgColorForRed(0.0, green: 0.0, blue: 0.0, myalpha: CGFloat(1.0)),
                    //cgColorForRed(25.0, green: 25.0, blue: 25.0, myalpha: CGFloat(1.0)),
                    //cgColorForRed(50.0, green: 50.0, blue: 50.0, myalpha: CGFloat(1.0)),
                    cgColorForRed(100.0, green: 100.0, blue: 100.0, myalpha: CGFloat(1.0)),
                    //cgColorForRed(50.0, green: 50.0, blue: 50.0, myalpha: CGFloat(1.0)),
                    //cgColorForRed(25.0, green: 25.0, blue: 25.0, myalpha: CGFloat(1.0)),
                    cgColorForRed(0.0, green: 0.0, blue: 0.0, myalpha: CGFloat (1.0))]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
                //gradientLayer.opacity = 0.5
                cellImageView.layer.addSublayer(gradientLayer)
                
                topLabel.text = meme.topText
                bottomLabel.text = meme.bottomText
            }
        }
    }
    
    private func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat, myalpha: CGFloat = 0.0) -> AnyObject {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: myalpha).CGColor as AnyObject
    }
}
