//
//  DetailViewController.swift
//  CollectionView
//
//  Created by Sam Finston on 6/17/19.
//  Copyright © 2019 Sam Finston. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selection: String! //Name of movie/show/person
    var image: String!
    var overview: String!
    var rating: Double!
    var labelStyle: (String, UIColor)!
    
    @IBOutlet private weak var detailsLabel: UILabel! //outlet to display the data
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textView: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var starRating: CosmosView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set name to label
        detailsLabel.text = selection
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        
        //Set poster to image view
        guard let imageUrl = URL(string: image) else { return }
        guard let imageData = try? Data(contentsOf: imageUrl) else { return }
        imageView.image = UIImage(data: imageData) ?? UIImage()
        
        //Set overview to text view
        textView.text = overview
        
        //Set contents and color of type label
        if let style = typeLabel {
            style.text = labelStyle.0
            style.backgroundColor = labelStyle.1
        }
        
        //Fill stars with correct rating or hide if not applicable
        if let stars = rating {
            starRating.rating = stars / 2
            starRating.settings.updateOnTouch = false
            starRating.settings.fillMode = .precise
        }
        else {
            starRating.isHidden = true
        }
        
    }

}
