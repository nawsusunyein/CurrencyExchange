//
//  CurrencyQuotes.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/4/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
import ObjectMapper

class CurrencyQuotes : Mappable{
    var AED : Float?
    var AFN : Float?
    var ALL : Float?
    var AMD : Float?
    var ANG : Float?
    var AOA : Float?
    var ARS : Float?
    var AUD : Float?
    var AWG : Float?
    var AZN : Float?
    var BAM : Float?
    var BBD : Float?
    var BDT : Float?
    var BGN : Float?
    
    init?(){}
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        AED <- map["USDAED"]
        AFN <- map["USDAFN"]
        ALL <- map["USDALL"]
        AMD <- map["USDAMD"]
        ANG <- map["USDANG"]
        AOA <- map["USDAOA"]
        ARS <- map["USDARS"]
        AUD <- map["USDAUD"]
        AWG <- map["USDAWG"]
        AZN <- map["USDAZN"]
        BAM <- map["USDBAM"]
        BBD <- map["USDBBD"]
        BDT <- map["USDBDT"]
        BGN <- map["USDBGN"]
        
        
    }
}
