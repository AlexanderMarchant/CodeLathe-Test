//
//  GiphyCell.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import UIKit
import SwiftyGif

class GiphyCell: UITableViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var gifTitleLabel: CLSubTitle!
    @IBOutlet weak var gifUsername: CLBody!
    @IBOutlet weak var gifMarkedTrendingDate: CLBody!
    @IBOutlet weak var gifSourceUrl: CLCaption!
    
    var model: GiphyCellViewModel! {
        didSet {
            
            let loader = UIActivityIndicatorView(style: .medium)
            gifImageView.setGifFromURL(model.gifUrl, customLoader: loader)
            
            self.gifTitleLabel.text = model.title
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
            
            self.gifMarkedTrendingDate.text = model.markedTrending
            self.gifSourceUrl.text = model.sourceUrl
            self.gifUsername.text = model.username ?? "Unknown"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.appColor(.background)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
