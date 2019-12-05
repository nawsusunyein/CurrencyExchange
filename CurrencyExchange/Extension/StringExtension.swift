//
//  StringExtension.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/5/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
extension String {
  subscript(_ range: CountableRange<Int>) -> String {
          let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
          let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
          return String(self[idx1..<idx2])
  }
    
 struct NumFormatter {
     static let instance = NumberFormatter()
 }

 var doubleValue: Double? {
     return NumFormatter.instance.number(from: self)?.doubleValue
 }

 var integerValue: Int? {
     return NumFormatter.instance.number(from: self)?.intValue
 }
}
