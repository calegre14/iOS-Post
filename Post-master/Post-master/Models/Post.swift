//
//  Post.swift
//  Post-New
//
//  Created by Eric Lanza on 11/28/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

struct Post: Codable {
    
    let text: String
    var timestamp: TimeInterval
    let username: String
    //queryTimeStamp - part 2
    
    init(text: String, username: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.text = text
        self.username = username
        self.timestamp = timestamp
    }
}


