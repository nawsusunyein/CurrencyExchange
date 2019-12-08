//
//  ErrorCodes.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/7/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
import ObjectMapper

class ErrorCodes : Mappable{
    var code : Int?
    var type : String?
    var info : String?
    
    init?(){}
    required init?(map : Map){}
    
    func mapping(map:Map){
        code <- map["code"]
        type <- map["type"]
        info <- map["info"]
    }
}
