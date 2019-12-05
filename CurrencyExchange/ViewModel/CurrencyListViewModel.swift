//
//  CurrencyListViewModel.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/5/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
struct CurrencyListViewModel{
    let currencyList : CurrencyList
    let enteredAmount : Double?
    let currencyType : String?
    
    private var currenyValueListDB = CurrencyValueListDB()
    
    private(set) var calculatedCurrencyList : [CalculatedCurrencyModel] = [CalculatedCurrencyModel]()
    
    init(currencyList : CurrencyList,enteredAmount : Double,currencyType : String){
        self.currencyList = currencyList
        self.enteredAmount = enteredAmount
        self.currencyType = currencyType
        self.getEvaluatedValues()
    }
    
    private mutating func getEvaluatedValues(){
        
        calculatedCurrencyList = setCurrencyDic(currencyList: self.currencyList)
        
        let calculatedCurrencyListFromDB = self.currenyValueListDB.getCurrencyListByCurrencyType(currencyType!)
        if calculatedCurrencyListFromDB.count > 0{
            self.currenyValueListDB.deleteCurrencyListByCurrencyType(currencyType: self.currencyType!)
            self.currenyValueListDB.insertCurrencyList(calculatedCurrencyList, currencyType: currencyType!)
           
        }
        
    }
    
}

extension CurrencyListViewModel {
    private mutating func setCurrencyDic(currencyList : CurrencyList) -> [CalculatedCurrencyModel]{
        var resultedCurrencyList : [CalculatedCurrencyModel] = [CalculatedCurrencyModel]()
        if (currencyList.quotes?.keys.count)! > 0{
            let sortedCurrencyListQuotes = currencyList.quotes?.sorted{ $0.key < $1.key}
            for (type,value) in sortedCurrencyListQuotes!{
                let currencyType = type[3..<type.count]
                let enteredUnitValue = enteredAmount! * value
                let calculatedCurrencyObject = CalculatedCurrencyModel(type: currencyType, oneUnitValue: value, enteredUnitValue: enteredUnitValue)
                resultedCurrencyList.append(calculatedCurrencyObject)
            }
        }
        return resultedCurrencyList
    }
}
