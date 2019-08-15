//
//  MovieSearchFunctions.swift
//  CollectionView
//
//  Created by Sam Finston on 6/18/19.
//  Copyright © 2019 Sam Finston. All rights reserved.
//

import Foundation

//Prints search result collection to the console
func printItems(items: [Itemable]) {
    for i in items {
        if i is ReviewedItem || i is Item {
            print(i.name)
            if let i = i as? ReviewedItem {
                print("review: \(i.average)\n")
            }
            else {
                print("")
            }
        }
    }
}

//Fetches search results from the API and parses the JSON into an array of Itemables
func searchMovies(query: String, completionBlock: @escaping ((_ results: [Itemable]) -> Void)){
    
    var items: [Itemable] = []
    
    let baseURL = "https://api.themoviedb.org/3/search/multi"
    let apiKey = "?api_key=71ab1b19293efe581c569c1c79d0f004&query="
    
    if let url = URL(string: baseURL + apiKey + query) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    
                    let res = try JSONDecoder().decode(Response.self, from: data)
                    
                    //print(res.total_results)
                    
                    //Converts search results (people/movies/shows) into items/reviewedItems
                    for r in res.results {
                        switch r.media_type {
                        case "person":
                            let person =
                                Item(name: r.name ?? "", type: r.media_type, image: r.profile_path)
                            items.append(person)
                        case "movie":
                            let movie =
                                ReviewedItem(name: r.title ?? "Untitled", type: r.media_type, image: r.poster_path, average: r.vote_average ?? 0, count: r.vote_count ?? 0, overview: r.overview ?? "No Overview Found")
                            items.append(movie)
                        case "tv":
                            let show =
                                ReviewedItem(name: r.name ?? "Untitled", type: r.media_type, image: r.poster_path, average: r.vote_average ?? 0, count: r.vote_count ?? 0, overview: r.overview ?? "No overview found")
                            items.append(show)
                        default:
                            break
                        }
                    }
                    
                    completionBlock(items)  //returns search results
                    
                } catch let error {
                    print(error)
                }
            }
            }.resume()
    }
    
}
