//
//  ExchangeListViewController.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/3/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import UIKit

class ExchangeListViewController: UIViewController {

    var apiService : ApiService = ApiService()
    private(set) var currencyListViewModel : CurrencyListViewModel?
    var currencyResultList : CurrencyList?{
        didSet{
            guard let currencyResultList =  currencyResultList else {
                return
            }
            currencyListViewModel = CurrencyListViewModel(currencyList: currencyResultList,enteredAmount: 12)
            self.currencyListTable.reloadData()
        }
    }
    
    @IBOutlet weak var currencyListTable: UITableView!
    @IBOutlet weak var txtEnteredAmount: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyListTable.dataSource = self
        self.currencyListTable.delegate = self
        
        self.currencyListTable.rowHeight = UITableView.automaticDimension
        self.currencyListTable.estimatedRowHeight = UITableView.automaticDimension
        
        self.registerTableViewCell()
    }

    private func registerTableViewCell(){
        self.currencyListTable.register(UINib.init(nibName: "ExchangeTableViewCell", bundle: nil), forCellReuseIdentifier: "ExchangeTableViewCell")
    }
    
    @IBAction func searchByCurrency(_ sender: Any) {
        
        let headers = [
          "Content-Type" : "application/json"
        ]
        
        let parameters : [String : Any] = [
            "source" : "USD" as AnyObject,
            "currencies" : "" as AnyObject,
            "format" : 1
        ]
        self.apiService.getLiveCurrencyList(headers:headers,parameters:parameters,success:{[] in
            guard let currencyList = self.apiService.currencyList else {return}
            self.currencyResultList = currencyList
        },
        failure:{[] in})
    }
    

}

extension ExchangeListViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currencyListViewModel = currencyListViewModel else{return 0}
        return currencyListViewModel.calculatedCurrencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeTableViewCell", for: indexPath) as! ExchangeTableViewCell
        cell.lblCurrencyType.text = currencyListViewModel?.calculatedCurrencyList[indexPath.row].type
        cell.lblCurrencyUnitValue.text = currencyListViewModel?.calculatedCurrencyList[indexPath.row].oneUnitValue?.description
        cell.lblCurrencyEnteredAmountValue.text = currencyListViewModel?.calculatedCurrencyList[indexPath.row].enteredUnitValue?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
