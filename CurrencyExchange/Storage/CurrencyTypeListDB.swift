//
//  CurrencyTypeListDB.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/5/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
import SQLite3

class CurrencyTypeListDB {
    private let CURRENCY_TYPE_LIST_TABLE = "CurrencyTypeListTable"
      private let CURRENCY_TYPE = "CurrencyType"

      private var db : OpaquePointer?
      
      init() {
            //the database file
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("CurrencyExchange.sqlite")
                
                //opening the database
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("Error opening database")
                }
                
                //creating a statement
                var stmt: OpaquePointer?
                
              
                
          let queryString = "CREATE TABLE IF NOT EXISTS \(CURRENCY_TYPE_LIST_TABLE)" +
          "(\(CURRENCY_TYPE) TEXT)"
         
                //creating table
                if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK {
                    if sqlite3_step(stmt) == SQLITE_DONE {
                        print("Currency Type List Table Created")
                    } else {
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("Currency Type list talbe can't be created : \(errmsg)")
                    }
                } else {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("Create Type list table statement can't be prepared : \(errmsg)")
                }
                sqlite3_finalize(stmt)
      }
      

      func insertCurrencyType(_ currencyTypeList : [String]){
          var stmt : OpaquePointer?
          for currency in currencyTypeList{
              let queryString = "INSERT INTO \(CURRENCY_TYPE_LIST_TABLE)" +
              "(\(CURRENCY_TYPE)) VALUES(?);"
              
              //preparing the query
              if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                  let errmsg = String(cString: sqlite3_errmsg(db)!)
                  print("\(self.CURRENCY_TYPE_LIST_TABLE) : Error preparing insert: \(errmsg)")
                  sqlite3_finalize(stmt)
                  return
              }else{
                  let currencyType = currency as NSString
                  
                  if(sqlite3_bind_text(stmt, 1, currencyType.utf8String, -1, nil) != SQLITE_OK){
                      let errmsg = String(cString: sqlite3_errmsg(db)!)
                      print("\(self.CURRENCY_TYPE_LIST_TABLE) : Error binding : \(errmsg)")
                      sqlite3_finalize(stmt)
                      return
                  }
                  
                  if(sqlite3_step(stmt) == SQLITE_DONE){
                      print("\(self.CURRENCY_TYPE_LIST_TABLE) : Inserted successfully \(currencyType)")
                  }else{
                      let errmsg = String(cString : sqlite3_errmsg(db)!)
                      print("\(self.CURRENCY_TYPE_LIST_TABLE) : Error Inserted : \(errmsg)")
                  }
              }
          }
          
      }
    
    func getCurrencyTypeList() -> [String]{
        var currencyTypeList : [String]? = [String]()
        var stmt : OpaquePointer?
        
        let queryString = "SELECT * FROM \(self.CURRENCY_TYPE_LIST_TABLE);"
        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("\(self.CURRENCY_TYPE_LIST_TABLE) : Error preparing : \(errmsg)")
        }
        
        var typeList : [String]?
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            if(typeList == nil){
                typeList = [String]()
            }
            let type = String(cString:sqlite3_column_text(stmt,0))
            typeList?.append(type)
        }
        
        if(typeList != nil && typeList!.count > 0){
            currencyTypeList = typeList
        }
        
        sqlite3_finalize(stmt)
        return currencyTypeList!
    }
}
