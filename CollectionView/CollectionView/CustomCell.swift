//
//  CustomCell.swift
//  CollectionView
//
//  Created by Sam Finston on 6/26/19.
//  Copyright © 2019 Sam Finston. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var bgImage: UIImageView!
}
