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
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldRanking: UITextField!
    @IBAction func buttonSave(_ sender: UIButton) {
        let name = textFieldName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let powerrank = textFieldRanking.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (name?.isEmpty)! {
            print("Name is empty")
            return;
        }
        
        if (powerrank?.isEmpty)! {
            print("Power rank is empty")
            return;
        }
        
        var stmt: OpaquePointer?
        
        let insertQuery = "INSERT INTO Heroes (name, powerrank) VALUES (?,?)"
        
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK {
            print("Error binding query")
        }
        
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK {
            print("Error binding name")
        }
        
        if sqlite3_bind_int(stmt, 2, (powerrank! as NSString).intValue) != SQLITE_OK {
            print("Error binding powerrank")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Hero saved succesfully")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("HeroDatabase.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, powerrank INTEGER)"
        
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

