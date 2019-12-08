//
//  CurrencyListFromDBViewModel.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/7/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
struct CurrencyListFromDBViewModel{
    var currencyListFromDb : [CalculatedCurrencyModel]
    let enteredAmount : Double?
    let currencyType : String?
    
    private(set) var calculatedCurrencyListFromDb : [CalculatedCurrencyModel] = [CalculatedCurrencyModel]()
    
    init(currencyListFromDb : [CalculatedCurrencyModel],enteredAmount : Double,currencyType : String){
        self.currencyListFromDb = currencyListFromDb
        self.enteredAmount = enteredAmount
        self.currencyType = currencyType
        getEvaluatedValues()
    }
    
    private mutating func getEvaluatedValues(){
        calculatedCurrencyListFromDb = self.setEnteredAmoutValue(currencyListFromDb: self.currencyListFromDb)
    }
}

extension CurrencyListFromDBViewModel{
    private mutating func setEnteredAmoutValue(currencyListFromDb : [CalculatedCurrencyModel]) -> [CalculatedCurrencyModel]{
        var calculateCurrencyList : [CalculatedCurrencyModel] = [CalculatedCurrencyModel]()
        if(currencyListFromDb.count > 0){
            for value in currencyListFromDb{
                let enteredUnitValue = Double(value.oneUnitValue!) * Double(self.enteredAmount!)
                let currencyListObject = CalculatedCurrencyModel(type: value.type!, oneUnitValue: value.oneUnitValue!, enteredUnitValue: enteredUnitValue)
                calculateCurrencyList.append(currencyListObject)
            }
        }
        return calculateCurrencyList
    }
}
