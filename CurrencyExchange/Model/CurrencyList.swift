//
//  CurrencyList.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/4/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
import ObjectMapper

class CurrencyList : Mappable{
    
    var success : Bool?
    var terms : String?
    var privacy : String?
    var timestamp : Double?
    var source : String?
    var quotes : [String : Float]?
    
    init?(){}
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        terms <- map["terms"]
        privacy <- map["privacy"]
        timestamp <- map["timestamp"]
        source <- map["source"]
        quotes <- map["quotes"]
    }
}
