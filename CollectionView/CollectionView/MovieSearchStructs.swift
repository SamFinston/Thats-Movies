//
//  MovieSearch.swift
//  CollectionView
//
//  Created by Sam Finston on 6/18/19.
//  Copyright © 2019 Sam Finston. All rights reserved.
//

import Foundation

//Struct to store all search results in
struct Response: Codable { // or Decodable
    var page: Int
    var total_results: Int
    var total_pages: Int
    var results: [Result]
}

//Struct to store individual results
struct Result: Codable {
    var media_type: String
    
    var title: String? //movie
    var name: String? //show or person
    var profile_path: String? //person
    
    //movie or show
    var poster_path: String?
    var vote_average: Double?
    var vote_count: Int?
    var overview: String?
}

enum Media { case movie, show, person }

//Protocol describing minimum requirements to be shown as a search item
protocol Itemable {
    var name: String { get }
    var type: Media { get }
    var image: String? { get }
}

extension Itemable {
//    init(name: String?, type: Media, image: String) {
//        self.init(name: name, type: type, image: "https://image.tmdb.org/t/p/w500/" + image)
//    }

    func getImagePath(urlEnd: String?) -> String {
        if let urlEnd = image {
            return "https://image.tmdb.org/t/p/w500/" + urlEnd
        }
        else {
            return "https://people.rit.edu/sxf5282/230/error/hypnotoad.gif"
        }
    }
    
    func getTypeEnum(typeString: String) -> Media {
        switch typeString {
        case "tv":
            return Media.show
        case "person":
            return Media.person
        default:
            return Media.movie
        }
    }
}

//Item without review data (people)
struct Item: Itemable {
    let name: String
    let type: Media
    let image: String?
    
    init(name: String, type: String, image: String?) {
        self.name = name
        
        switch type {
        case "tv":
            self.type = Media.show
        case "person":
            self.type = Media.person
        default:
            self.type = Media.movie
        }
        
        if let imagePath = image {
            self.image = "https://image.tmdb.org/t/p/w500/" + imagePath
        }
        else {
            self.image = "https://people.rit.edu/sxf5282/230/error/hypnotoad.gif"
        }
        
    }
}

//Item with review data
struct ReviewedItem: Itemable {
    let name: String
    let type: Media
    let image: String?
    
    let average: Double
    let count: Int
    let overview: String
    
    init(name: String, type: String, image: String?, average: Double, count: Int, overview: String) {
        self.name = name
        self.average = average
        self.count = count
        self.overview = overview
        
        switch type {
        case "tv":
            self.type = Media.show
        case "person":
            self.type = Media.person
        default:
            self.type = Media.movie
        }
        
        if let imagePath = image {
            self.image = "https://image.tmdb.org/t/p/w500/" + imagePath
        }
        else {
            self.image = "https://people.rit.edu/sxf5282/230/error/hypnotoad.gif"
        }
        
    }
}
