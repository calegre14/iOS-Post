//
//  PostListViewController.swift
//  Post-New
//
//  Created by Eric Lanza on 11/28/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Properties
    let postController = PostController()
    var refreshControll = UIRefreshControl()
    
    //MARK:- Outlets
    @IBOutlet weak var postsTableView: UITableView!
    
    //MARK:- View
    override func viewDidLoad() {
        super.viewDidLoad()
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.estimatedRowHeight = 45
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.refreshControl = refreshControll
        refreshControll.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts {
            self.reloadTableView()
        }
    }
    //MARK:- Actions
    @IBAction func addPostButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Post", message: "Would you be a dear, and write something here?", preferredStyle: .alert)
        
        var usernameText: UITextField?
        var messageBodyText: UITextField?
        
        alert.addTextField { (usernameTextField) in
            usernameText = usernameTextField
            usernameText?.placeholder = "Enter your Username"
        }
        alert.addTextField { (bodyTextField) in
            messageBodyText = bodyTextField
            messageBodyText?.placeholder = "Enter your post"
        }
        let postAction = UIAlertAction(title: "Add Post", style: .default) { (postAction) in
            guard let username = usernameText?.text, !username.isEmpty,
                let text = messageBodyText?.text, !text.isEmpty else {return}
            self.postController.addNewPostWith(username: username, text: text, completion: self.reloadTableView)
            if username.isEmpty || text.isEmpty {
                self.presentErrorAlert()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(postAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Functions
    func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.postsTableView.reloadData()
        }
    }
    
    func presentErrorAlert() {
        let alertError = UIAlertController(title: "Missing info", message: "Make sure you filled everthing out", preferredStyle: .alert)
        alertError.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(alertError, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username) - \(Date(timeIntervalSince1970: post.timestamp))"
        
        return cell
    }
    
    @objc func refreshControlPulled() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts {
            self.reloadTableView()
            DispatchQueue.main.async {
                self.refreshControll.endRefreshing()
            }
        }
    }
    
}




