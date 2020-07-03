//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Hunter McNeil on 6/30/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {

    @IBOutlet weak var postListSearchBar: UISearchBar!
    
    var resultsArray: [Post] = []
    var isSearching: Bool = false
    var dataSource: [Post] {
        if isSearching == true {
            return resultsArray
        } else {
            return PostController.shared.posts
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postListSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        resultsArray = PostController.shared.posts
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
        
        let post = dataSource[indexPath.row]
        cell.post = post
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? PostDetailTableViewController else {return}
            let postToSend = dataSource[indexPath.row]
            destination.post = postToSend
        }
    }
}

extension PostListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let posts = PostController.shared.posts
        var searchArray: [Post] = []
        guard let searchTerm = postListSearchBar.text?.lowercased(), !searchTerm.isEmpty else {return}
        
        for post in posts {
            if post.matches(searchTerm: searchTerm) {
                searchArray.append(post)
            }
        }
        resultsArray = searchArray
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = PostController.shared.posts
        postListSearchBar.text = ""
        postListSearchBar.resignFirstResponder()
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
}
