//
//  SavedMemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 3/5/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class SavedMemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!
    
    var meme: Meme? {
        didSet {
            if let newMeme = meme {
                backgroundView = UIImageView(image: newMeme.originalImage)
                
                //Add a vertical gradient that makes top/bottom labels stand out better
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = self.backgroundView!.bounds
                gradientLayer.name = "topbottom_gradient"
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
                backgroundView!.layer.addSublayer(gradientLayer)

                topLabel.text = newMeme.topText
                bottomLabel.text = newMeme.bottomText
            }
        }
    }
    
    var editing = false {
        didSet {
            topLabel.hidden = editing
            bottomLabel.hidden = editing
            selectionImage.hidden = !editing
        }
    }
    
    override var selected: Bool {
        didSet {
            if editing {
                selectionImage.image = UIImage(named: selected ? "cell_checked" : "cell_unchecked")
            }
        }
    }
    //Ensure gradient keeps in sync everytime cell layout changes
    override func layoutSubviews() {
        super.layoutSubviews()
        for l in backgroundView!.layer.sublayers {
            (l as? CAGradientLayer)?.frame = backgroundView!.bounds
        }
    }
    
    
    private func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat, alpha myalpha: CGFloat = 0.0) -> AnyObject {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: myalpha).CGColor as AnyObject
    }
}
