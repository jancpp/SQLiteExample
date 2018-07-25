//
//  Hero.swift
//  SQLiteExample
//
//  Created by Jan Polzer on 7/24/18.
//  Copyright © 2018 Apps KC. All rights reserved.
//

import Foundation

class Hero
{
    var id: Int
    var name: String?
    var powerranking: Int
    
    init(id: Int, name: String?, powerranking: Int) {
        self.id = id
        self.name = name
        self.powerranking = powerranking
        
    }
}
