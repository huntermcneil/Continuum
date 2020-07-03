//
//  Comment.swift
//  Continuum
//
//  Created by Hunter McNeil on 6/30/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import Foundation
import CloudKit

struct CommentConstants {
    static let recordTypeKey = "Comment"
    fileprivate static let textKey = "text"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let postReferenceKey = "postReference"
}

class Comment {
    var text: String
    var timestamp: Date
    weak var post: Post?
    var recordID: CKRecord.ID
    
    var postReference: CKRecord.Reference? {
        guard let post = post else {return nil}
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    init(text: String, timestamp: Date = Date(), post: Post?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
        self.recordID = recordID
    }
}

extension CKRecord {
    convenience init(comment: Comment) {
        self.init(recordType: CommentConstants.recordTypeKey, recordID: comment.recordID)
        
        setValuesForKeys([
            CommentConstants.textKey : comment.text,
            CommentConstants.timestampKey : comment.timestamp,
            CommentConstants.postReferenceKey : comment.postReference
        ])
    }
}

extension Comment {
    convenience init?(ckRecord: CKRecord, post: Post) {
        guard let text = ckRecord[CommentConstants.textKey] as? String,
            let timestamp = ckRecord[CommentConstants.timestampKey] as? Date else {return nil}
        
        self.init(text: text, timestamp: timestamp, post: post)
    }
}
