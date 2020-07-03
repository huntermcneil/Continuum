//
//  PostError.swift
//  Continuum
//
//  Created by Hunter McNeil on 6/30/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import Foundation

enum PostError: LocalizedError {
    case unableToUnwrap
    case thrownError(Error)
}
