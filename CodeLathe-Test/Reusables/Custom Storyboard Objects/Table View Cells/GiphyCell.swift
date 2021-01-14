//
//  GiphyCell.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import UIKit

class GiphyCell: UITableViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var gifTitleLabel: CLSubTitle!
    @IBOutlet weak var gifUsername: CLBody!
    @IBOutlet weak var gifMarkedTrendingDate: CLBody!
    @IBOutlet weak var gifSourceUrl: CLCaption!
    
    var model: GiphyCellViewModel! {
        didSet {
            
            downloadImage(from: model.gifUrl) { [weak self] (data, response, error) in
            
                guard let data = data,
                      let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                      error == nil else {
                    
                    print("Something went wrong, log the error")
                    print("ERROR: \(error!.localizedDescription)")
                    
                    DispatchQueue.main.async() { [weak self] in
                        self?.gifImageView.image = UIImage(named: "image-not-found")!
                    }
                    
                    return
                }
                
                print("Download Finished")
                
                DispatchQueue.main.async() { [weak self] in
                    self?.gifImageView.image = UIImage(data: data)
                }
            }
            
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func downloadImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
