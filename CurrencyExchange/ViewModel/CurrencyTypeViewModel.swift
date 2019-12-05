//
//  CurrencyTypeViewModel.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/5/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
struct CurrencyTypeViewModel{
    let currencyKeyValueList : [String : Double]?
    
    private(set) var currencyTypeList : [String] = [String]()
    
    private var currencyTypeListDB : CurrencyTypeListDB = CurrencyTypeListDB()
    
    init(currencyKeyValueList : [String : Double]){
        self.currencyKeyValueList = currencyKeyValueList
        emulatedCurrencyTypes()
    }
    
    private mutating func emulatedCurrencyTypes(){
        self.currencyTypeList = self.setCurrencyValuesType(currencyKeyValueList: self.currencyKeyValueList!)
        self.currencyTypeListDB.insertCurrencyType(self.currencyTypeList)
    }
}

extension CurrencyTypeViewModel{
    private mutating func setCurrencyValuesType(currencyKeyValueList : [String : Double]) -> [String]{
        var currencyValueTypes : [String] = [String]()
        if(currencyKeyValueList.keys.count > 0){
            for (key,_) in currencyKeyValueList{
                let currencyType = key[3..<key.count]
                currencyValueTypes.append(currencyType)
            }
        }
       
        return currencyValueTypes
    }
}
