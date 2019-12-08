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
    var LIVE_API = API.Host.BASE + API.EndPoint.LIVE + API.AccessKey.access_key
    
    var currencyList : CurrencyList?
    
    func getLiveCurrencyList(headers : HTTPHeaders? = nil, parameters : Parameters? = nil, success : @escaping() -> (), failure : @escaping() -> ()){
        Alamofire.request(LIVE_API,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers).responseObject{(response:DataResponse<CurrencyList>) in
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
