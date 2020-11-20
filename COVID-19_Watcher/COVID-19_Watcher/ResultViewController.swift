//
//  ResultViewController.swift
//  COVID-19_Watcher
//
//  Created by 杜逸凡 on 2020/11/20.
//  Copyright © 2020 杜逸凡. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var dataDict:[String: String] = [
        "nowConfirm": "",
        "confirm": "",
        "suspect": "",
        "dead": "",
        "heal": ""
    ]
    var cityName: String = ""
    
    func jsonStrToDict(jsonStr: String) -> [String:String] {
        var jsonData =  [String: String]()
        var jsonKey: String = ""
        var jsonValue: String = ""
        var kvJudge:Bool = true
        for char in jsonStr {
            if char == "," {
                jsonData.updateValue(jsonValue.trimmingCharacters(in: .whitespacesAndNewlines), forKey: jsonKey.trimmingCharacters(in: .whitespacesAndNewlines))
                jsonKey = ""
                jsonValue = ""
                kvJudge = !kvJudge
            } else if char == ":"{
                kvJudge = !kvJudge
            } else if char == "}" {
                jsonData.updateValue(jsonValue.trimmingCharacters(in: .whitespacesAndNewlines), forKey: jsonKey.trimmingCharacters(in: .whitespacesAndNewlines))
                break
            } else if char != "\"" && char != "{" {
                if kvJudge {
                    jsonKey = jsonKey + String(char)
                } else {
                    jsonValue = jsonValue + String(char)
                }
            }
        }
        
        return jsonData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(cityName)
        var signal = true
        
        let url = "http://api.sagiri-web.com/epidemicInquire/?area=\(self.cityName)".urlEncoded()
        let myUrl = URL(string: url)
        let urlRequest = URLRequest(url: myUrl!)

        // session
        let session = URLSession.shared

        // task
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            // check for error
            guard error == nil else {
                let alertController = UIAlertController(title: "网络请求错误!请检查网络！", message: nil, preferredStyle: .alert)
                //显示提示框
                self.present(alertController, animated: true, completion: nil)
                //两秒钟后自动消失
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
                print("Error: error is not nil")
                return
            }
            // check for data
            guard let responseData = data else {
                print("Error: data is nil")
                let alertController = UIAlertController(title: "HTTP请求无返回数据!", message: nil, preferredStyle: .alert)
                //显示提示框
                self.present(alertController, animated: true, completion: nil)
                //两秒钟后自动消失
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
                return
            }
            
            do {
                var html: String = ""
                html = String(data: responseData, encoding: String.Encoding.utf8) ?? ""
                for _ in 1 ..< 9 {
                    html.remove(at: html.startIndex)
                }
                
                let jsonDic: [String:String] = self.jsonStrToDict(jsonStr: html)
                print(jsonDic)
                self.dataDict["nowConfirm"] = jsonDic["nowConfirm"]
                self.dataDict["confirm"] = jsonDic["confirm"]
                self.dataDict["suspect"] = jsonDic["suspect"]
                self.dataDict["dead"] = jsonDic["dead"]
                self.dataDict["heal"] = jsonDic["heal"]
            } catch {
                print("解析出错")
            }
            signal = false
        }
        task.resume()
        while signal {}
        print(dataDict)
        nowConfirm.text = "目前确诊:\(String(dataDict["nowConfirm"] ?? "-1"))"
        confirm.text = "确诊总数:\(String(dataDict["confirm"] ?? "-1"))"
        suspect.text = "疑似总数:\(String(dataDict["suspect"] ?? "-1"))"
        dead.text = "死亡总数:\(String(dataDict["dead"] ?? "-1"))"
        heal.text = "治愈总数:\(String(dataDict["heal"] ?? "-1"))"
        if nowConfirm.text == "目前确诊:-1" {
            let alertController = UIAlertController(title: "未查询到结果!", message: nil, preferredStyle: .alert)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
            //两秒钟后自动消失
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    
    @IBOutlet weak var nowConfirm: UILabel!
    @IBOutlet weak var confirm: UILabel!
    @IBOutlet weak var suspect: UILabel!
    @IBOutlet weak var dead: UILabel!
    @IBOutlet weak var heal: UILabel!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
