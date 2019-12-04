//
//  ApiService.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/4/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class ApiService {
    
    var currencyList : CurrencyList?
    
    func getLiveCurrencyList(headers : HTTPHeaders? = nil, parameters : Parameters? = nil, success : @escaping() -> (), failure : @escaping() -> ()){
        Alamofire.request("http://apilayer.net/api/live?access_key=0db6e628644d0e90a4062e77b6c7ea72",method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers).responseObject{(response:DataResponse<CurrencyList>) in
            switch response.result{
            case .success(_) :
                self.currencyList = response.result.value
                success()
                break
            case .failure(_):
                failure()
                break
            }
        }
    }
}
