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
    let enteredAmount : Float?
    
    private(set) var calculatedCurrencyList : [CalculatedCurrencyModel] = [CalculatedCurrencyModel]()
    
    init(currencyList : CurrencyList,enteredAmount : Float){
        self.currencyList = currencyList
        self.enteredAmount = enteredAmount
        self.getEvaluatedValues()
    }
    
    private mutating func getEvaluatedValues(){
        calculatedCurrencyList = setCurrencyDic(currencyList: self.currencyList)
    }
    
}

extension CurrencyListViewModel {
    private mutating func setCurrencyDic(currencyList : CurrencyList) -> [CalculatedCurrencyModel]{
        var resultedCurrencyList : [CalculatedCurrencyModel] = [CalculatedCurrencyModel]()
        if (currencyList.quotes?.keys.count)! > 0{
            for (type,value) in currencyList.quotes!{
                let enteredUnitValue = enteredAmount! * value
                let calculatedCurrencyObject = CalculatedCurrencyModel(type: type, oneUnitValue: value, enteredUnitValue: enteredUnitValue)
                resultedCurrencyList.append(calculatedCurrencyObject)
            }
        }
        return resultedCurrencyList
    }
}
