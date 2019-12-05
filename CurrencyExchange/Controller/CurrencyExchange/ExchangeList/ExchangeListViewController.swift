//
//  ExchangeListViewController.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/3/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import UIKit
import iOSDropDown

class ExchangeListViewController: UIViewController,UITextFieldDelegate{

    var apiService : ApiService = ApiService()
    private(set) var currencyListViewModel : CurrencyListViewModel?
    private(set) var currencyTypeListViewModel : CurrencyTypeViewModel?
    
    var currencyResultList : CurrencyList?{
        didSet{
            guard let currencyResultList =  currencyResultList else {
                return
            }
            currencyListViewModel = CurrencyListViewModel(currencyList: currencyResultList,enteredAmount: self.enteredAmount,currencyType:self.selectedCurrency)
            self.currencyListTable.reloadData()
        }
    }
    
    var currencyTypeList : [String]? {
        didSet{
            guard let currencyTypeList = currencyTypeList else{
                return
            }
            if(currencyTypeList.count > 0){
                bindCurrencyTypes(currencyTypeList)
            }else{
                self.getCurrencyList(source: "USD", isFindingType: true)
            }
        }
    }
    
    var currencyKeyValueList : [String : Double]? {
        didSet{
            guard let currencyKeyValueList = currencyKeyValueList else{
                return
            }
            currencyTypeListViewModel = CurrencyTypeViewModel(currencyKeyValueList : currencyKeyValueList)
            bindCurrencyTypes(self.currencyTypeListViewModel!.currencyTypeList)
        }
    }
    
    private var currencyTypeListDB : CurrencyTypeListDB = CurrencyTypeListDB()
    private var currencyValueListDB : CurrencyValueListDB = CurrencyValueListDB()
    
    private var enteredAmount : Double = 0
    private var selectedCurrency : String = "USD"
    private var isFirstTime : Bool = true
    private var startDateTime : Date = Date()
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var currencyListTable: UITableView!
    @IBOutlet weak var txtEnteredAmount: UITextField!
    @IBOutlet weak var currencyTypeDropDown: DropDown!
    
    @IBOutlet weak var txtResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyListTable.dataSource = self
        self.currencyListTable.delegate = self
        
        self.txtEnteredAmount.delegate = self
        
        self.currencyListTable.rowHeight = UITableView.automaticDimension
        self.currencyListTable.estimatedRowHeight = UITableView.automaticDimension
        self.makeRoundedButton(button: btnSearch)
        self.registerTableViewCell()
        self.getCurrencyTypeList()
        self.setResultValue()
        
        self.getCurrencyList(source: self.selectedCurrency,isFindingType: false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    private func registerTableViewCell(){
        self.currencyListTable.register(UINib.init(nibName: "ExchangeTableViewCell", bundle: nil), forCellReuseIdentifier: "ExchangeTableViewCell")
    }
    
    private func makeRoundedButton(button : UIButton){
        button.layer.cornerRadius = 5
    }
    
    private func getCurrencyTypeList(){
        self.currencyTypeList = self.currencyTypeListDB.getCurrencyTypeList()
    }
    
    private func bindCurrencyTypes(_ currencyTypeList : [String]){
        currencyTypeDropDown.optionArray = currencyTypeList
        currencyTypeDropDown.didSelect{(selectedText,index,id) in
            self.selectedCurrency = selectedText
        }
    }
    
    @IBAction func searchByCurrency(_ sender: Any) {
        let enteredAmountString = self.txtEnteredAmount.text
        if let doubleEnteredAmount = enteredAmountString?.doubleValue{
            self.enteredAmount = doubleEnteredAmount
        }else{
            showErrorAlert(message: "Please enter integer or decimal value")
            return
        }
        self.setResultValue()
        let currentDateTime = Date()
        let timeInterval = self.startDateTime.timeIntervalSince(currentDateTime)
        let timeInteger = NSInteger(timeInterval)
        let minutes = abs((timeInteger / 60) % 60)
        
        if(minutes > 30){
            self.getCurrencyList(source: self.selectedCurrency,isFindingType: false)
        }else{
            
        }
       
        
    }
  
    private func setResultValue(){
        self.txtResult.text = "Result for : \nCurrency Type : \(self.selectedCurrency) \nEntered Amount : \(self.enteredAmount)"
    }
    private func showErrorAlert(message : String){
        let warningAlert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {_ in})
        warningAlert.addAction(okAction)
        self.present(warningAlert, animated: true, completion: nil)
    }
    
    private func getCurrencyList(source : String,isFindingType : Bool){
        let headers = [
                 "Content-Type" : "application/json"
               ]
               
               let parameters : [String : Any] = [
                   "source" : source as AnyObject,
                   "currencies" : "" as AnyObject,
                   "format" : 1
               ]
               self.apiService.getLiveCurrencyList(headers:headers,parameters:parameters,success:{[] in
                   guard let currencyList = self.apiService.currencyList else {return}
                if(isFindingType){
                    self.currencyKeyValueList = self.apiService.currencyList?.quotes
                }else{
                    self.currencyResultList = currencyList
                }
                   
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
