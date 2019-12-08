//
//  CurrencyValueListDB.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/5/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
import SQLite3

class CurrencyValueListDB {
    private let CURRENCY_VALUE_LIST_TABLE = "CurrencyValueListTable"
    private let CURRENCY_TYPE = "CurrencyType"
    private let CURRENCY_VALUE = "CurrencyValue"
    private let CURRENCY_SOURCE = "CurrencySource"
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
              
            
              
        let queryString = "CREATE TABLE IF NOT EXISTS \(CURRENCY_VALUE_LIST_TABLE)" +
        "(\(CURRENCY_TYPE) TEXT," +
        "\(CURRENCY_VALUE) DOUBLE," +
        "\(CURRENCY_SOURCE) TEXT)"
              //creating table
              if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK {
                  if sqlite3_step(stmt) == SQLITE_DONE {
                      print("Currency List Table Created")
                  } else {
                      let errmsg = String(cString: sqlite3_errmsg(db)!)
                      print("Currency list talbe can't be created : \(errmsg)")
                  }
              } else {
                  let errmsg = String(cString: sqlite3_errmsg(db)!)
                  print("Create table statement can't be prepared : \(errmsg)")
              }
              sqlite3_finalize(stmt)
    }
    

    func insertCurrencyList(_ currencyList : [CalculatedCurrencyModel],currencyName : String){
        var stmt : OpaquePointer?
        for currency in currencyList{
            let queryString = "INSERT INTO \(CURRENCY_VALUE_LIST_TABLE)" +
            "(\(CURRENCY_TYPE)," +
            "\(CURRENCY_VALUE)," +
            "\(CURRENCY_SOURCE)) VALUES(?,?,?);"
            
            //preparing the query
            if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("\(self.CURRENCY_VALUE_LIST_TABLE) : Error preparing insert: \(errmsg)")
                sqlite3_finalize(stmt)
                return
            }else{
                let currencyType = currency.type! as NSString
                let currencyValue = currency.oneUnitValue
                let currencySource = currencyName as NSString
                
                if(sqlite3_bind_text(stmt, 1, currencyType.utf8String, -1, nil) != SQLITE_OK){
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("\(self.CURRENCY_VALUE_LIST_TABLE) : Error binding : \(errmsg)")
                    sqlite3_finalize(stmt)
                    return
                }
                
                if(sqlite3_bind_double(stmt, 2, currencyValue!) != SQLITE_OK){
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("\(self.CURRENCY_VALUE_LIST_TABLE) : Error binding : \(errmsg)")
                    sqlite3_finalize(stmt)
                    return
                }
                
                if(sqlite3_bind_text(stmt, 3, currencySource.utf8String, -1, nil) != SQLITE_OK){
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("\(self.CURRENCY_VALUE_LIST_TABLE) : Error binding : \(errmsg)")
                }
                
                if(sqlite3_step(stmt) == SQLITE_DONE){
                    print("\(self.CURRENCY_VALUE_LIST_TABLE) : Inserted successfully \(currencyType)")
                }else{
                    let errmsg = String(cString : sqlite3_errmsg(db)!)
                    print("\(self.CURRENCY_VALUE_LIST_TABLE) : Error Inserted : \(errmsg)")
                }
            }
        }
        
    }
    
    func getCurrencyListByCurrencyType(_ currencyType : String) -> [CalculatedCurrencyModel]{
        var stmt : OpaquePointer?
        var calculatedCurrencyList : [CalculatedCurrencyModel] = [CalculatedCurrencyModel]()
        let currencyTypeString = "'" + currencyType + "'"
        
        let queryString = "SELECT * FROM \(self.CURRENCY_VALUE_LIST_TABLE) WHERE \(self.CURRENCY_SOURCE) = \(currencyTypeString);"
            
            if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("\(self.CURRENCY_VALUE_LIST_TABLE) : Error preparing query all : \(errmsg)")
                sqlite3_finalize(stmt)
                return calculatedCurrencyList
            }
            
            var list : [CalculatedCurrencyModel]?
            
            while(sqlite3_step(stmt) == SQLITE_ROW){
                if(list == nil){
                    list = [CalculatedCurrencyModel]()
                }
                
                let currencyType = String(cString:sqlite3_column_text(stmt, 0))
                let currencyValue = sqlite3_column_double(stmt, 1)
                let currencyObj = CalculatedCurrencyModel.init(type: currencyType, oneUnitValue: currencyValue, enteredUnitValue: 0.0)
                list?.append(currencyObj)
            }
            
            if list != nil && (list?.count)! > 0{
                calculatedCurrencyList = list!
            }
            sqlite3_finalize(stmt)
            return calculatedCurrencyList
        }
        
    func deleteCurrencyListByCurrencyType(currencyType : String){
        var stmt : OpaquePointer?
        let currencyTypeString = "'" + currencyType + "'"
        let queryString = "DELETE FROM \(self.CURRENCY_VALUE_LIST_TABLE) WHERE \(self.CURRENCY_SOURCE) = \(currencyTypeString);"
        
        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("\(self.CURRENCY_VALUE_LIST_TABLE) : Error preparing to delete : \(errmsg)")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            print("\(self.CURRENCY_VALUE_LIST_TABLE) : Successfully deleted row . \(currencyTypeString)")
        }else{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("\(self.CURRENCY_VALUE_LIST_TABLE) : Could not delte row : \(errmsg)")
        }
        sqlite3_finalize(stmt)
        
    }
}
