//
//  ViewController.swift
//  iStore
//
//  Created by Nikita Skrypchenko  on 2/15/19.
//  Copyright © 2019 Nikita Skrypchenko . All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothinFoundCell = "NothingFoundCell"
        }
    }
    var searchResults = [SearchResult]()
    var hasSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothinFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothinFoundCell)
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0{
            return nil
        }else{
            return indexPath
        }
    }
    
    func performStoreRequest(with url: URL) -> Data? {
        do{
            //returns a new string object with the data it receives from the server pointed to by the URL.
            return try Data(contentsOf: url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func iTunesURL(_ searchString: String) -> URL{
        let encodedString = searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@", encodedString)
        let url = URL(string: urlString)
        return url!
    }
    
    func parse(_ data: Data) -> [SearchResult]{
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print(error)
            return []
        }
    }
    
}
//invoked when the "Search" button clicked on keyboard
extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty{
            searchBar.resignFirstResponder()
            hasSearched = true
            searchResults = []
            let url = iTunesURL(searchBar.text!)
            print("URL: '\(url)'")
            if let data = performStoreRequest(with: url) {
                let results = parse(data)
                print("\(results)")
            }
            tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        }
        else if searchResults.count == 0 {
            return 1
        }else{
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        searchBar.resignFirstResponder()
        if searchResults.count == 0{
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothinFoundCell, for: indexPath)
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            cell.artistNameLabel.text = searchResult.name
            cell.nameLabel.text = searchResult.artistName
            return cell
        }
        
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}

