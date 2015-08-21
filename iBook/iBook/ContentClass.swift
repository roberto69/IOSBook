//
//  ContentClass.swift
//  iBook
//
//  Created by Guillaume on 19/08/2015.
//  Copyright (c) 2015 Guillaume. All rights reserved.
//

import UIKit

class ContentClass: NSObject {
    
    var title: String
    var text: String
    var url: String
    
    init(title: String, text: String, url: String) {
        self.title = title
        self.text = text
        self.url = url
        super.init()
    }
}