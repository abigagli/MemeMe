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
                //self.backgroundView.image = meme.originalImage
                self.backgroundView = UIImageView(image: meme.originalImage)
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = self.backgroundView!.bounds
                gradientLayer.colors = [
                    cgColorForRed(255.0, green: 255.0, blue: 255.0, alpha:CGFloat(0.8)),
                    cgColorForRed(255.0, green: 255.0, blue: 255.0, alpha:CGFloat(0.5)),
                    cgColorForRed(0.0, green: 0.0, blue: 0.0),
                    cgColorForRed(0.0, green: 0.0, blue: 0.0),
                    cgColorForRed(0.0, green: 0.0, blue: 0.0),
                    cgColorForRed(200.0, green: 200.0, blue: 200.0, alpha: CGFloat(0.5)),
                    cgColorForRed(200.0, green: 200.0, blue: 200.0, alpha: CGFloat (0.8))]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
                //gradientLayer.opacity = 0.5
                self.backgroundView!.layer.addSublayer(gradientLayer)
                
                topLabel.text = meme.topText
                bottomLabel.text = meme.bottomText
            }
        }
    }
    
    private func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat, alpha myalpha: CGFloat = 0.0) -> AnyObject {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: myalpha).CGColor as AnyObject
    }
}
