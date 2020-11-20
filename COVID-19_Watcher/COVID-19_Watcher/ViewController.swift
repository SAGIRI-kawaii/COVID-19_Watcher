//
//  ViewController.swift
//  COVID-19_Watcher
//
//  Created by 杜逸凡 on 2020/11/19.
//  Copyright © 2020 杜逸凡. All rights reserved.
//

import UIKit
import os.log

extension String {
     
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        return encodeUrlString ?? ""
    }
     
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}

class ViewController: UIViewController   {
    
//    var dataDict:[String: String] = [
//        "nowConfirm": "",
//        "confirm": "",
//        "suspect": "",
//        "dead": "",
//        "heal": ""
//    ]
    var html: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is ResultViewController){
            self.cityName = String(inputField.text!)
            let target = segue.destination as! ResultViewController
//            target.dataDict = self.dataDict
            target.cityName = self.cityName
        }
    }
    
    var cityName: String = ""
    
    var nowConfirmint: Int = 0
    var confirmStr: Int = 0
    var suspectStr: Int = 0
    var deadStr: Int = 0
    var healStr: Int = 0
    
    @IBOutlet weak var inputField: UITextField!
    
    @IBAction func searchButton(_ sender: UIButton) {
    }
    
}

