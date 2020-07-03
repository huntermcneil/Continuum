//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Hunter McNeil on 7/1/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool 
}
