//
//  ViewController.swift
//  SQLiteExample
//
//  Created by Jan Polzer on 7/22/18.
//  Copyright © 2018 Apps KC. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var db: OpaquePointer?
    var heroList = [Hero]()
    
    @IBOutlet weak var tableViewHeroes: UITableView!
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
            print("Hero saved succesfully in \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        }
        
        readValues()
        textFieldName.text = ""
        textFieldRanking.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewHeroes.delegate = self
        tableViewHeroes.dataSource = self
        
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
        readValues()
    }
    
    func readValues() {
        
        // Empty the list of heroes
        heroList.removeAll()
        
        // Select query
        let queryString = "SELECT * FROM Heroes"
        
        // Statement pointer
        var stmt:OpaquePointer?
        
        // Prepare the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // Traverse through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let powerrank = sqlite3_column_int(stmt, 2)
            
            // Add values to list
            heroList.append(Hero(id: Int(id), name: String(describing: name), powerranking: Int(powerrank)))
        }
        self.tableViewHeroes.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let hero: Hero
        hero = heroList[indexPath.row]
        cell.textLabel?.text = hero.name
        
        return cell
    }
}

