//
//  CalculatedCurrencyModel.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/5/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
class CalculatedCurrencyModel{
    
    var type : String?
    var oneUnitValue : Float?
    var enteredUnitValue : Float?
    
    init(type:String,oneUnitValue:Float,enteredUnitValue:Float){
        self.type = type
        self.oneUnitValue = oneUnitValue
        self.enteredUnitValue = enteredUnitValue
    }
}
