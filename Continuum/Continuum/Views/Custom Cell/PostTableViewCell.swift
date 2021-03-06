//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Hunter McNeil on 6/30/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var postCommentsLabel: UILabel!
    
    var post: Post? {
        didSet {
        updateViews()
    }
}
    
    func updateViews() {
        guard let post = post else {return}
        postImageView.image = post.photo
        postCaptionLabel.text = post.caption
        postCommentsLabel.text = "Comments: \(post.comments.count)"
    }
}
