//
//  SearchResultModel.swift
//  iStore
//
//  Created by Nikita Skrypchenko  on 2/16/19.
//  Copyright © 2019 Nikita Skrypchenko . All rights reserved.
//

import Foundation

class ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

class SearchResult: Codable, CustomStringConvertible{
    var trackName: String? = ""
    var artistName: String? = ""
    
    var name:String {
        return trackName ?? ""
    }
    
    var description: String{
        return "Name: \(name), Artists Name: \(artistName ?? "None")"
    }
}
