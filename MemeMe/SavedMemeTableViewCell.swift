//
//  SavedMemeTableViewCell.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 3/5/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class SavedMemeTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var meme: Meme? {
        didSet {
            if let meme = meme {
                cellImageView.image = meme.memedImage
                topLabel.text = meme.topText
                bottomLabel.text = meme.bottomText
            }
        }
    }
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */

}
