//
//  ViewController.swift
//  CollectionView
//
//  Created by Sam Finston on 6/17/19.
//  Copyright © 2019 Sam Finston. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //Variables
    var collectionData: [Itemable] = []
    var searchBar = UISearchBar()
    var titleQuery: String!
    
    //Constants
    private enum Constants {
        static let collectionViewCellId = "CollectionViewCell"
    }
    
    //Functions
    
    ///Returns UIImage from given url String
    func getImageFromURL(url: String) -> UIImage {
        guard let imageUrl = URL(string: url) else { return UIImage() }
        guard let imageData = try? Data(contentsOf: imageUrl) else { return UIImage() }
        return UIImage(data: imageData) ?? UIImage()
    }

    //Runs when page is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up search bar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        searchBar.text = titleQuery //add title screen's search query to the bar
        searchBar.barStyle = .black
        
        //Make everything green in the search bar
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            
            //Text
            searchField.textColor = #colorLiteral(red: 0.05098039216, green: 0.1098039216, blue: 0.137254902, alpha: 1)
            
            //Placeholder text
            if let placeholderText = searchField.value(forKey: "placeholderLabel") as? UILabel {
                placeholderText.textColor = #colorLiteral(red: 0.05098039216, green: 0.1098039216, blue: 0.137254902, alpha: 0.5)
            }
            
            //Search icon
            if let searchIcon = searchField.leftView as? UIImageView {
                searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
                searchIcon.tintColor = #colorLiteral(red: 0.05468450487, green: 0.146376878, blue: 0.183096081, alpha: 1)
            }
            
            //Cancel icon
            //Gave up on this one
            
        }
        
        searchAndPopulate() //perform search from title screen
        self.navigationItem.titleView = searchBar //add to nav bar
        
        //Cell formatting
        let width = (view.frame.size.width - 20) / 1 //set cell width to be responsive, accounting for spacing (1 column)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout //has item size property
        layout.itemSize = CGSize(width: width, height: width / 2)
        
    }
    
    //Returns the corresponding text and background color of the type label for a Media enum
    func getTypeLabel(type: Media) -> (String, UIColor) {
        var labelText: String
        var labelColor: UIColor
        
        switch type {
        case .movie:
            labelText = "  Movie  "
            labelColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case .show:
            labelText = "  Show  "
            labelColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case .person:
            labelText = "  Actor  "
            labelColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        }
        
        return (labelText, labelColor)
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count //number of items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //create cell instance
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellId, for: indexPath)
        
        cell.layer.cornerRadius = 10.0 //round corners
        
        //Populate Cell
        
        if let customCell = cell as? CustomCell {
            //Title Label
            customCell.titleLabel.text = " " + collectionData[indexPath.row].name + " "
            customCell.titleLabel.clipsToBounds = true
            customCell.titleLabel.layer.cornerRadius = 10.0
            
            //Type Label
            let labelStyle = getTypeLabel(type: collectionData[indexPath.row].type)
            customCell.typeLabel.text = labelStyle.0
            customCell.typeLabel.backgroundColor = labelStyle.1
            
            //Star Rating
            if let item = collectionData[indexPath.row] as? ReviewedItem {
                customCell.starRating.rating = item.average / 2
                customCell.starRating.settings.updateOnTouch = false
                customCell.starRating.settings.fillMode = .precise
            }
            else {
                customCell.starRating.isHidden = true
            }
            
            //Background Image
            //This adds lag, maybe try: DispatchQueue.global(qos: .background).async
            guard let url = collectionData[indexPath.row].image else { return cell }
            customCell.bgImage.image = getImageFromURL(url: url)
        }
        
        
        return cell
    }
    
    //runs when cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Not in use
    }
    
    //Sends data from selected cell to details page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailSegue" {
            if let dest = segue.destination as?
                DetailViewController, let index = collectionView.indexPathsForSelectedItems?.first {
                
                dest.selection = collectionData[index.row].name
                dest.image = collectionData[index.row].image
                dest.labelStyle = getTypeLabel(type: collectionData[index.row].type)
                if let t = collectionData[index.row] as? ReviewedItem {
                    dest.overview = t.overview
                    dest.rating = t.average
                }
                else {
                    dest.overview = "N/A"
                }
            }
        }
    }
}

//Search functions
extension ViewController: UISearchBarDelegate {
    
    //On search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchAndPopulate()
    }
    
    //Performs search and updates collection view with results
    func searchAndPopulate() {
        
        //Fills new array from search results
        var newData: [Itemable] = []
    
        //Don't search if search bar is empty
        if searchBar.text! == "" {
            return
        }
        
        searchMovies(query: searchBar.text!) { [weak self] results in
        guard let self = self else { return } //if self exists
    
        for i in results {
        if i is ReviewedItem || i is Item {
            newData.append(i) //Cell Label
        }
        }
    
        //replaces data array and updates UI in the main thread
        self.collectionData = newData
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    
        }
    }
}
