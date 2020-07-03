//
//  Post.swift
//  Continuum
//
//  Created by Hunter McNeil on 6/30/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

struct PostConstants {
    static let recordTypeKey = "Post"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let captionKey = "caption"
    fileprivate static let commentsKey = "comments"
    fileprivate static let imageAssetKey = "imageAsset"
}

class Post {
    var photoData: Data?
    var timestamp: Date
    var caption: String
    var comments: [Comment]
    var recordID: CKRecord.ID
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let finalURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            
            do {
                try photoData?.write(to: finalURL)
            } catch {
                print("There was an error - \(error) - \(error.localizedDescription)")
        }
            return CKAsset(fileURL: finalURL)
    }
}
    
    var photo: UIImage? {
        get {
            if let data = self.photoData {
                guard let image = UIImage(data: data) else {return nil}
                return image
            } else {
                return nil
            }
        }
        set {
            let newData = newValue?.jpegData(compressionQuality: 1)
            self.photoData = newData
        }
    }
    
    init(photo:UIImage?, caption: String, timestamp: Date = Date(), comments: [Comment], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.caption = caption
        self.timestamp = timestamp
        self.comments = comments
        self.recordID = recordID
        self.photo = photo
    }
}

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if self.caption.contains(searchTerm) {
            return true
        } else {
            return false
        }
    }
}

extension CKRecord {
    convenience init?(post: Post) {
        self.init(recordType: PostConstants.recordTypeKey, recordID: post.recordID)
       
        setValuesForKeys([
            PostConstants.captionKey : post.caption,
            PostConstants.timestampKey : post.timestamp,
        ])
    }
}

extension Post {
    convenience init?(ckRecord: CKRecord) {
        guard let caption = ckRecord[PostConstants.captionKey] as? String,
            let timestamp = ckRecord[PostConstants.timestampKey] as? Date else {return nil}
        
        var foundPhoto: UIImage?
        
        if let imageAsset = ckRecord[PostConstants.imageAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: imageAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Failed with error - \(error) - \(error.localizedDescription)")
            }
        }
        self.init( photo: foundPhoto, caption: caption, timestamp: timestamp, comments: [], recordID: ckRecord.recordID)
    }
}
