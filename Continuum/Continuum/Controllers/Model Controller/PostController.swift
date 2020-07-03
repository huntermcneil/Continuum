//
//  PostController.swift
//  Continuum
//
//  Created by Hunter McNeil on 6/30/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class PostController {
    
    static let shared = PostController()
    
    var posts: [Post] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func addComment(text: String, post: Post, completion: @escaping (Result<Post?, PostError>) -> Void) {
        
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment)
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Result<Post?, PostError>) -> Void) {
        
        let newPost = Post(photo: image, caption: caption, comments: [])
        guard let record = CKRecord(post: newPost) else {return completion(.failure(.unableToUnwrap))}
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("There was an error - \(error) - \(error.localizedDescription)")
                return completion(.failure(.thrownError(error)))
            }
            guard let record = record,
                let savedPost = Post(ckRecord: record) else {return completion(.failure(.unableToUnwrap))}
            self.posts.append(savedPost)
        }
        
        PostController.shared.posts.append(newPost)
    }
    
}
