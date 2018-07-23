//
//  ViewController.swift
//  SQLiteExample
//
//  Created by Jan Polzer on 7/22/18.
//  Copyright © 2018 Apps KC. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    var db: OpaquePointer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("HeroDatabase.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Heros (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, powerrank INTEGER)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        
        print("Everything worked")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

