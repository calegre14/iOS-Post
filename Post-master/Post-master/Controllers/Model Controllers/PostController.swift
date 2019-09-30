//
//  PostController.swift
//  Post-New
//
//  Created by Eric Lanza on 11/28/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class PostController {
    
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    var posts: [Post] = []
    
     func fetchPosts(completion: @escaping() -> Void) {
        guard let url = baseURL else {fatalError("URL optional is nil")}
        let getterEndPoint = url.appendingPathExtension("json")
        var request = URLRequest(url: getterEndPoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion()
                return
            }
            guard let data = data else {completion(); return}
            let jsonDecoder = JSONDecoder()
            do {
                
                let postDictionary = try jsonDecoder.decode([String:Post].self, from: data)
                var posts: [Post] = postDictionary.compactMap({$0.value})
                posts.sort(by: { $0.timestamp > $1.timestamp})
                self.posts = posts
                completion()
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion()
                return
            }
        }
        dataTask.resume()
    }
}
