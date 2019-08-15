//
//  TitleViewController.swift
//  CollectionView
//
//  Created by Sam Finston on 6/20/19.
//  Copyright © 2019 Sam Finston. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        //Make everything green in the search bar
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            
            //Text
            searchField.textColor = #colorLiteral(red: 0, green: 0.8381955028, blue: 0.5291469693, alpha: 1)
            
            //Placeholder text
            if let placeholderText = searchField.value(forKey: "placeholderLabel") as? UILabel {
                placeholderText.textColor = #colorLiteral(red: 0, green: 0.8381955028, blue: 0.5294117647, alpha: 0.5)
            }
            
            //Search icon
            if let searchIcon = searchField.leftView as? UIImageView {
                searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
                searchIcon.tintColor = #colorLiteral(red: 0, green: 0.8381955028, blue: 0.5291469693, alpha: 1)
            }
            
            //Cancel icon
            //Gave up on this one
            
        }
        
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TitleViewController: UISearchBarDelegate {
    
    //On search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.performSegue(withIdentifier: "toMain", sender: nil)
    }
    
    //Send search query to main search page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMain" {
            if let dest = segue.destination as? ViewController {
                dest.titleQuery = searchBar.text
            }
        }
    }
    
}
